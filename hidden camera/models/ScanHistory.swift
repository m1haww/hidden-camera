import Foundation

struct ScanHistoryItem: Codable, Identifiable {
    let id: UUID
    let date: Date
    let scanType: ScanType
    let devicesFound: Int
    let devices: [DeviceInfo]
    
    enum ScanType: String, Codable {
        case wifi = "Wi-Fi"
        case bluetooth = "Bluetooth"
        case lan = "LAN"
    }
    
    struct DeviceInfo: Codable {
        let name: String
        let address: String // MAC or IP address
        let signalStrength: Int?
        let manufacturer: String?
        let type: String?
    }
    
    init(scanType: ScanType, devices: [DeviceInfo]) {
        self.id = UUID()
        self.date = Date()
        self.scanType = scanType
        self.devicesFound = devices.count
        self.devices = devices
    }
}

extension ScanHistoryItem {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var summary: String {
        "\(devicesFound) \(scanType.rawValue) device\(devicesFound == 1 ? "" : "s") found"
    }
}