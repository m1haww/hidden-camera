import Foundation
import LanScanner
import SwiftUI

func isSecureDevice(_ device: LanDevice) -> Bool {
    let isTrustedBrand = trustedBrands.contains(where: { device.brand.localizedCaseInsensitiveContains($0) })
    let isTrustedName = trustedNameKeywords.contains(where: { device.name.localizedCaseInsensitiveContains($0) })

    let isIpPrivateRange = device.ipAddress.starts(with: "192.168.") || device.ipAddress.starts(with: "10.")
    
    let isLikelyGateway = device.ipAddress.split(separator: ".").last == "1"

    return isTrustedBrand || isTrustedName || isIpPrivateRange || isLikelyGateway
}

let trustedBrands = ["Apple", "Samsung", "Dell", "HP", "Sony", "Canon", "Brother"]
let trustedNameKeywords = ["iPhone", "iPad", "Mac", "Printer", "NAS", "Router"]

final class NetworkScanner: ObservableObject {
    static let shared = NetworkScanner()
    
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var bluetoothManager = BeaconScanner.shared
    
    private init() {}
    
    @Published var connectedDevices = [WiFiDevice]()
    @Published var progress: CGFloat = .zero
    
    @Published var showAlertAtFinish: Bool = false
    
    @Published var isScanning: Bool = false
    
    private lazy var scanner = LanScanner(delegate: self)
    
    func start() {
        connectedDevices.removeAll()
        progress = .zero
        isScanning = true
        scanner.start()
    }
    
    func stop() {
        isScanning = false
        progress = .zero
        scanner.stop()
    }
}

extension NetworkScanner: LanScannerDelegate {
    func lanScanHasUpdatedProgress(_ progress: CGFloat, address: String) {
        self.progress = progress
    }
    
    func lanScanDidFindNewDevice(_ device: LanDevice) {
        let wifiDevice = WiFiDevice(device: device)
        wifiDevice.isSecure = isSecureDevice(device)
        connectedDevices.append(wifiDevice)
    }
    
    func lanScanDidFinishScanning() {
        isScanning = false
        progress = .zero
        bluetoothManager.stopScanning()
        
        if showAlertAtFinish {
            withAnimation {
                appProvider.showAlert = true
            }
        }
    }
}
