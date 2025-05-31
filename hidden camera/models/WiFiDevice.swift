import Foundation
import LanScanner

final class WiFiDevice: ObservableObject, Identifiable, Equatable, Hashable {
    var data: LanDevice
    let id: UUID = UUID()
    
    @Published var isSecure: Bool = false
    
    init(device: LanDevice) {
        self.data = device
    }
    
    static func == (lhs: WiFiDevice, rhs: WiFiDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
