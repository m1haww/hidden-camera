import Foundation

struct NativeWiFiDevice: Identifiable, Equatable, Hashable {
    let id = UUID()
    let ipAddress: String
    let hostname: String?
    let macAddress: String?
    let vendor: String?
    let isReachable: Bool
    let discoveryMethod: DiscoveryMethod
    let services: [String]
    
    enum DiscoveryMethod {
        case bonjour
        case arp
        case ping
        case combined
    }
    
    var deviceType: String {
        // Determine device type based on services and vendor
        if services.contains(where: { $0.contains("airplay") || $0.contains("raop") }) {
            return "Apple Device"
        } else if services.contains(where: { $0.contains("printer") || $0.contains("ipp") }) {
            return "Printer"
        } else if services.contains(where: { $0.contains("http") || $0.contains("https") }) {
            return "Web Server"
        } else if let vendor = vendor {
            return vendor
        } else {
            return "Unknown Device"
        }
    }
    
    var isSecure: Bool {
        let trustedVendors = ["Apple", "Samsung", "Dell", "HP", "Sony", "Canon", "Brother", "Microsoft", "Google"]
        let trustedServices = ["_airplay", "_raop", "_ipp", "_printer", "_homekit", "_companion-link"]
        
        if let vendor = vendor, trustedVendors.contains(where: { vendor.localizedCaseInsensitiveContains($0) }) {
            return true
        }
        
        if services.contains(where: { service in
            trustedServices.contains(where: { service.contains($0) })
        }) {
            return true
        }
        
        // Check if it's a router (typically .1 address)
        if ipAddress.hasSuffix(".1") || ipAddress.hasPrefix("192") {
            return true
        }
        
        return false
    }
    
    static func == (lhs: NativeWiFiDevice, rhs: NativeWiFiDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
