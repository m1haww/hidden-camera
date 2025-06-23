import Foundation
import SwiftUI

class ScanHistoryManager: ObservableObject {
    static let shared = ScanHistoryManager()
    
    @Published var scanHistory: [ScanHistoryItem] = []
    
    private let fileName = "scan_history.json"
    private let maxHistoryItems = 100 // Limit history to prevent file from growing too large
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var historyFileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    private init() {
        loadHistory()
    }
    
    func loadHistory() {
        guard FileManager.default.fileExists(atPath: historyFileURL.path) else {
            print("No history file found")
            return
        }
        
        do {
            let data = try Data(contentsOf: historyFileURL)
            let decoder = JSONDecoder()
            scanHistory = try decoder.decode([ScanHistoryItem].self, from: data)
            print("Loaded \(scanHistory.count) history items")
        } catch {
            print("Error loading history: \(error)")
        }
    }
    
    func saveHistory() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(scanHistory)
            try data.write(to: historyFileURL)
            print("History saved successfully")
        } catch {
            print("Error saving history: \(error)")
        }
    }
    
    func addScan(_ item: ScanHistoryItem) {
        // Add new scan at the beginning
        scanHistory.insert(item, at: 0)
        
        // Limit history size
        if scanHistory.count > maxHistoryItems {
            scanHistory = Array(scanHistory.prefix(maxHistoryItems))
        }
        
        saveHistory()
    }
    
    func clearHistory() {
        scanHistory.removeAll()
        
        // Delete the file
        do {
            try FileManager.default.removeItem(at: historyFileURL)
            print("History cleared")
        } catch {
            print("Error clearing history: \(error)")
        }
    }
    
    func deleteScan(at offsets: IndexSet) {
        scanHistory.remove(atOffsets: offsets)
        saveHistory()
    }
    
    // Helper method to create scan history from network scanner results
    func createWiFiScanHistory(from devices: [NetworkScanner.NetworkDevice]) -> ScanHistoryItem {
        let deviceInfos = devices.map { device in
            ScanHistoryItem.DeviceInfo(
                name: device.hostname ?? "Unknown Device",
                address: device.ipAddress,
                signalStrength: nil,
                manufacturer: device.macVendor,
                type: "Wi-Fi Device"
            )
        }
        
        return ScanHistoryItem(scanType: .wifi, devices: deviceInfos)
    }
    
    func createBluetoothScanHistory(from devices: [Peripheral]) -> ScanHistoryItem {
        let deviceInfos = devices.map { device in
            ScanHistoryItem.DeviceInfo(
                name: device.name,
                address: device.id.uuidString,
                signalStrength: device.rssi,
                manufacturer: nil,
                type: "Bluetooth Device"
            )
        }
        
        return ScanHistoryItem(scanType: .bluetooth, devices: deviceInfos)
    }
    
    func createLANScanHistory(from devices: [WiFiDevice]) -> ScanHistoryItem {
        let deviceInfos = devices.map { device in
            ScanHistoryItem.DeviceInfo(
                name: device.hostname,
                address: device.ipAddress,
                signalStrength: nil,
                manufacturer: device.brand,
                type: "LAN Device"
            )
        }
        
        return ScanHistoryItem(scanType: .lan, devices: deviceInfos)
    }
}
