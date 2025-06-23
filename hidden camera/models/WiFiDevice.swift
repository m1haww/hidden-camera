import Foundation

final class WiFiDevice: ObservableObject, Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    
    let ipAddress: String
    let hostname: String
    let brand: String
    let name: String
    let macAddress: String
    
    @Published var isSecure: Bool = false
    
    init(ipAddress: String, hostname: String, brand: String, name: String, macAddress: String, isSecure: Bool = false) {
        self.ipAddress = ipAddress
        self.hostname = hostname
        self.brand = brand
        self.name = name
        self.macAddress = macAddress
        self.isSecure = isSecure
    }
    
    init(nativeDevice: NativeWiFiDevice) {
        self.ipAddress = nativeDevice.ipAddress
        self.hostname = nativeDevice.hostname ?? "Unknown"
        self.brand = nativeDevice.vendor ?? nativeDevice.deviceType
        self.name = nativeDevice.hostname ?? nativeDevice.deviceType
        self.macAddress = nativeDevice.macAddress ?? "Unknown"
        self.isSecure = nativeDevice.isSecure
    }
    
    static func == (lhs: WiFiDevice, rhs: WiFiDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
