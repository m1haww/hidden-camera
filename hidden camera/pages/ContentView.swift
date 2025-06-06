import SwiftUI

struct ContentView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ZStack {
            if appProvider.showPaywall {
                InAppPaywallView()
            } else {
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
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipped()
                            Text("Settings")
                        }
                        .tag(3)
                }
                .accentColor(.customButton)
                .blur(radius: appProvider.showAlert ? 10 : 0)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(Color.customBackground)
                    
                    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
                    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                        .foregroundColor: UIColor.white.withAlphaComponent(0.5)
                    ]
                    
                    appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.customButton)
                    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                        .foregroundColor: UIColor(Color.customButton)
                    ]
                    
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .scanResultDetail: ScanResultDetailView()
                    case .wifiDeviceDetail(let device): LanDeviceDetailView(device: device)
                    case .bluetoothDeviceDetail(let device): BluetoothDeviceDetailView(device: device)
                    case .blinkingScanner: BlinkingScannerView()
                    case .compassVisualDetail: CompassVisualDetailView()
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
}
