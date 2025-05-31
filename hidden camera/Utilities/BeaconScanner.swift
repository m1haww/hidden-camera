import Foundation
import CoreBluetooth

struct Peripheral: Identifiable, Hashable, Equatable {
    let id: UUID
    let name: String
    let rssi: Int
}

final class BeaconScanner: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BeaconScanner()
    
    var myCentral: CBCentralManager!
    
    @Published var isSwitchOn: Bool = false
    
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheralUUID: UUID?
    
    @Published var isScanning = false
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchOn = central.state == .poweredOn
    }
    
    func startScanning() {
        peripherals.removeAll()
        isScanning = true
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        isScanning = false
        myCentral.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func connect(to peripheral: Peripheral) {
        guard let cgPeripheral = myCentral.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Could not find the peripheral \(peripheral.id)")
            return
        }
        
        connectedPeripheralUUID = peripheral.id
        cgPeripheral.delegate = self
        myCentral.connect(cgPeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
        
        if !peripherals.contains(where: { $0.id == newPeripheral.id }) {
            DispatchQueue.main.async {
                self.peripherals.append(newPeripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed to connect to \(peripheral.identifier): \(String(describing: error))")
        
        if peripheral.identifier == connectedPeripheralUUID {
            connectedPeripheralUUID = nil
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("Disconnected from \(peripheral.identifier): \(String(describing: error))")
        
        if peripheral.identifier == connectedPeripheralUUID {
            connectedPeripheralUUID = nil
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let services = peripheral.services {
            for service in services {
                print("Disovered service: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Disovered characteristic: \(characteristic.uuid)")
            }
        }
    }
}
