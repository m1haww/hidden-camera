import SwiftUI

struct ContentView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ZStack {
            NavigationStack(path: $appProvider.navigationPath) {
                TabView {
                    FirstView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipped()
                            Text("Scan")
                        }
                        .tag(0)
                    
                    SecondView()
                        .tabItem {
                            Image(systemName: "waveform.path.ecg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipped()
                            Text("Instruments")
                        }
                        .tag(1)
                    
                    ThirdView()
                        .tabItem {
                            Image(systemName: "book.closed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipped()
                            Text("Guides")
                        }
                        .tag(2)
                }
                .accentColor(.customButton)
                .blur(radius: appProvider.showAlert ? 10 : 0)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .scanResultDetail: ScanResultDetailView()
                    case .wifiDeviceDetail(let device): LanDeviceDetailView(device: device)
                    case .bluetoothDeviceDetail(let device): BluetoothDeviceDetailView(device: device)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Cam Detector")
                            .foregroundStyle(.white)
                            .font(.title2)
                    }
                }
            }
            
            if appProvider.showAlert {
                ScanResultView(scannedDeviceType: "Test")
            }
        }
    }
}
