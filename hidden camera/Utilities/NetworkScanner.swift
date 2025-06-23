import Foundation
import SwiftUI
import Combine

final class NetworkScanner: ObservableObject {
    static let shared = NetworkScanner()
    
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var bluetoothManager = BeaconScanner.shared
    
    private let nativeScanner = NativeNetworkScanner.shared
    
    private init() {
        setupBindings()
    }
    
    struct NetworkDevice {
        let ipAddress: String
        let hostname: String?
        let macAddress: String?
        let macVendor: String?
        let isReachable: Bool
    }
    
    @Published var connectedDevices = [WiFiDevice]()
    @Published var progress: CGFloat = .zero
    
    @Published var showAlertAtFinish: Bool = false
    
    @Published var isScanning: Bool = false
    
    private func setupBindings() {
        nativeScanner.$connectedDevices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nativeDevices in
                self?.connectedDevices = nativeDevices.map { WiFiDevice(nativeDevice: $0) }
            }
            .store(in: &cancellables)
        
        nativeScanner.$progress
            .receive(on: DispatchQueue.main)
            .assign(to: &$progress)
        
        nativeScanner.$isScanning
            .receive(on: DispatchQueue.main)
            .assign(to: &$isScanning)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        nativeScanner.showAlertAtFinish = showAlertAtFinish
        nativeScanner.start()
    }
    
    func stop() {
        nativeScanner.stop()
    }
}
