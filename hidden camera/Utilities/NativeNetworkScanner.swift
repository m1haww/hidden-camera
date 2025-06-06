import Foundation
import Network
import SwiftUI

final class NativeNetworkScanner: ObservableObject {
    static let shared = NativeNetworkScanner()
    
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var bluetoothManager = BeaconScanner.shared
    
    private init() {}
    
    @Published var connectedDevices = [NativeWiFiDevice]()
    @Published var progress: CGFloat = .zero
    @Published var showAlertAtFinish: Bool = false
    @Published var isScanning: Bool = false
    
    private var bonjourBrowser: NWBrowser?
    private var scanTimer: Timer?
    private let scanQueue = DispatchQueue(label: "com.hiddencamera.networkscan", attributes: .concurrent)
    private var scannedIPs = Set<String>()
    private var totalIPsToScan = 0
    private var scannedIPsCount = 0
    
    func start() {
        connectedDevices.removeAll()
        progress = .zero
        isScanning = true
        scannedIPs.removeAll()
        scannedIPsCount = 0
        
        // Start Bonjour discovery
        startBonjourDiscovery()
        
        // Start IP range scan
        startIPRangeScan()
    }
    
    func stop() {
        isScanning = false
        progress = .zero
        bonjourBrowser?.cancel()
        bonjourBrowser = nil
        scanTimer?.invalidate()
        scanTimer = nil
    }
    
    private func startBonjourDiscovery() {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        // Browse for common services
        let services = ["_http._tcp", "_https._tcp", "_airplay._tcp", "_raop._tcp", "_ipp._tcp", "_printer._tcp", "_homekit._tcp"]
        
        for service in services {
            let browser = NWBrowser(for: .bonjour(type: service, domain: "local"), using: parameters)
            
            browser.browseResultsChangedHandler = { [weak self] results, changes in
                self?.handleBonjourResults(results, service: service)
            }
            
            browser.start(queue: scanQueue)
            
            // Keep reference to prevent deallocation
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                browser.cancel()
            }
        }
    }
    
    private func handleBonjourResults(_ results: Set<NWBrowser.Result>, service: String) {
        for result in results {
            switch result.endpoint {
            case .service(let name, let type, let domain, _):
                scanQueue.async { [weak self] in
                    self?.resolveService(name: name, type: type, domain: domain, service: service)
                }
            default:
                break
            }
        }
    }
    
    private func resolveService(name: String, type: String, domain: String, service: String) {
        // Try to resolve the service to get IP address
        let parameters = NWParameters.tcp
        let endpoint = NWEndpoint.service(name: name, type: type, domain: domain, interface: nil)
        let connection = NWConnection(to: endpoint, using: parameters)
        
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                if case .hostPort(let host, _) = connection.currentPath?.remoteEndpoint {
                    self?.addDeviceFromBonjour(host: host, serviceName: name, service: service)
                }
                connection.cancel()
            case .failed:
                connection.cancel()
            default:
                break
            }
        }
        
        connection.start(queue: scanQueue)
    }
    
    private func addDeviceFromBonjour(host: NWEndpoint.Host, serviceName: String, service: String) {
        var ipAddress: String?
        
        switch host {
        case .ipv4(let address):
            ipAddress = "\(address)"
        case .ipv6(let address):
            ipAddress = "\(address)"
        case .name(let hostname, _):
            // Try to resolve hostname to IP
            ipAddress = resolveHostname(hostname)
        @unknown default:
            break
        }
        
        guard let ip = ipAddress, !scannedIPs.contains(ip) else { return }
        scannedIPs.insert(ip)
        
        let device = NativeWiFiDevice(
            ipAddress: ip,
            hostname: serviceName,
            macAddress: getARPEntry(for: ip),
            vendor: nil,
            isReachable: true,
            discoveryMethod: .bonjour,
            services: [service]
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.connectedDevices.append(device)
        }
    }
    
    private func startIPRangeScan() {
        guard let localIP = getLocalIPAddress() else { return }
        
        let ipComponents = localIP.split(separator: ".")
        guard ipComponents.count == 4 else { return }
        
        let subnet = ipComponents[0...2].joined(separator: ".")
        totalIPsToScan = 254
        
        // Scan IP range in chunks to avoid overwhelming the system
        let chunkSize = 10
        var currentChunk = 1
        
        scanTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, self.isScanning else { return }
            
            let startIP = currentChunk
            let endIP = min(currentChunk + chunkSize - 1, 254)
            
            for i in startIP...endIP {
                let ip = "\(subnet).\(i)"
                if !self.scannedIPs.contains(ip) {
                    self.scanQueue.async {
                        self.checkHost(ip)
                    }
                }
            }
            
            currentChunk += chunkSize
            
            if currentChunk > 254 {
                self.scanTimer?.invalidate()
                self.finishScanning()
            }
        }
    }
    
    private func checkHost(_ ipAddress: String) {
        scannedIPsCount += 1
        updateProgress()
        
        // Simple reachability check using URLSession
        let url = URL(string: "http://\(ipAddress)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 2.0
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if response != nil || (error as? URLError)?.code == .cannotConnectToHost {
                // Host is reachable (even if it refuses the connection)
                self?.addDeviceFromIPScan(ipAddress: ipAddress, isReachable: true)
            }
        }
        task.resume()
        
        // Also try a simple socket connection
        checkSocketConnection(to: ipAddress)
    }
    
    private func checkSocketConnection(to ipAddress: String) {
        let queue = DispatchQueue(label: "socket.check.\(ipAddress)")
        queue.async { [weak self] in
            // Try common ports
            let ports = [80, 443, 22, 21, 23, 25, 110, 139, 445, 3389, 5900]
            
            for port in ports {
                if self?.tryConnection(to: ipAddress, port: port) == true {
                    self?.addDeviceFromIPScan(ipAddress: ipAddress, isReachable: true)
                    break
                }
            }
        }
    }
    
    private func tryConnection(to host: String, port: Int) -> Bool {
        let socketFD = socket(AF_INET, SOCK_STREAM, 0)
        guard socketFD != -1 else { return false }
        defer { close(socketFD) }
        
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = UInt16(port).bigEndian
        
        guard inet_pton(AF_INET, host, &addr.sin_addr) == 1 else { return false }
        
        let result = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(socketFD, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        
        return result == 0
    }
    
    private func addDeviceFromIPScan(ipAddress: String, isReachable: Bool) {
        guard !scannedIPs.contains(ipAddress) else { return }
        scannedIPs.insert(ipAddress)
        
        let device = NativeWiFiDevice(
            ipAddress: ipAddress,
            hostname: nil,
            macAddress: getARPEntry(for: ipAddress),
            vendor: getMACVendor(for: getARPEntry(for: ipAddress)),
            isReachable: isReachable,
            discoveryMethod: .ping,
            services: []
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.connectedDevices.append(device)
        }
    }
    
    private func updateProgress() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progress = CGFloat(self.scannedIPsCount) / CGFloat(self.totalIPsToScan)
        }
    }
    
    private func finishScanning() {
        DispatchQueue.main.async { [weak self] in
            self?.isScanning = false
            self?.progress = .zero
            self?.bluetoothManager.stopScanning()
            
            if self?.showAlertAtFinish == true {
                withAnimation {
                    self?.appProvider.showAlert = true
                }
            }
        }
    }
    
    // Helper functions
    private func getLocalIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                
                if addrFamily == UInt8(AF_INET) {
                    let name = String(cString: (interface?.ifa_name)!)
                    if name == "en0" || name == "en1" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    private func resolveHostname(_ hostname: String) -> String? {
        let host = CFHostCreateWithName(nil, hostname as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray? {
            for address in addresses {
                if let data = address as? Data {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    data.withUnsafeBytes { ptr in
                        guard let sockaddr = ptr.baseAddress?.assumingMemoryBound(to: sockaddr.self) else { return }
                        getnameinfo(sockaddr, socklen_t(data.count),
                                    &hostname, socklen_t(hostname.count),
                                    nil, 0, NI_NUMERICHOST)
                    }
                    return String(cString: hostname)
                }
            }
        }
        
        return nil
    }
    
    private func getARPEntry(for ipAddress: String) -> String? {
        // This is a simplified version - in production you might want to use system calls
        // or parse the ARP table more thoroughly
        return nil
    }
    
    private func getMACVendor(for macAddress: String?) -> String? {
        // In a real implementation, you'd have a database of MAC address prefixes
        // mapped to vendors
        return nil
    }
}