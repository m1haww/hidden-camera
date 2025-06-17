import SwiftUI

struct FirstView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    @State private var lastCompletedScanType: String = "Wi-Fi"
    
    @StateObject private var deviceInfoProvider = DeviceInfoProvider.shared
    @StateObject private var networkScanner = NetworkScanner.shared
    @StateObject private var bluetoothManager = BeaconScanner.shared
    
    var body: some View {
        ZStack {
            StyleGuide.Navigation.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: StyleGuide.Spacing.large) {
                VStack(alignment: .leading) {
                    InfoRow(
                        title: "Connection Type",
                        value: deviceInfoProvider.geoIPInfo?.mobile ?? false ? "Cellular" : "Wi-Fi"
                    )
                    Divider()
                        .background(Color.gray.opacity(0.5))
                    HStack {
                        Text("IP Address")
                            .foregroundColor(StyleGuide.Typography.captionColor)
                        Spacer()
                        
                        if let error = deviceInfoProvider.error {
                            Text("Error: \(error.localizedDescription)")
                                .foregroundColor(.red)
                        } else if let ipInfo = deviceInfoProvider.geoIPInfo?.query {
                            Text("\(ipInfo)")
                                .foregroundColor(StyleGuide.Typography.titleColor)
                        } else {
                            Text("No IP Info Available")
                                .foregroundColor(StyleGuide.Typography.titleColor)
                        }
                    }
                }
                .padding(.vertical, StyleGuide.Spacing.medium)
                .padding(.horizontal, StyleGuide.Cards.padding)
                .background(StyleGuide.Cards.backgroundColor)
                .cornerRadius(8)
                .padding(.horizontal, StyleGuide.Spacing.small)
                
                Spacer()
                
                VStack(spacing: StyleGuide.Spacing.medium) {
                    ZStack {
                        Circle()
                            .fill(StyleGuide.Navigation.backgroundColor)
                            .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: StyleGuide.Scanning.progressLineWidth)
                            .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                        
                        Circle()
                            .trim(from: 0.0, to: networkScanner.progress)
                            .stroke(Color.customButton, style: StrokeStyle(lineWidth: StyleGuide.Scanning.progressLineWidth, lineCap: .round))
                            .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.5), value: networkScanner.progress)
                        
                        Image("searchicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: StyleGuide.Scanning.iconSize, height: StyleGuide.Scanning.iconSize)
                            .foregroundColor(networkScanner.isScanning ? Color(hex: "29B684") : (networkScanner.progress >= 1.0 ? .customButton : .gray))
                    }
                    
                    if networkScanner.isScanning {
                        Text("\(Int(networkScanner.progress * 100))%")
                            .font(.title2)
                            .foregroundColor(.customText)
                    }
                }
                
                Text("Scan nearby Wi-Fi and Bluetooth networks to monitor and analyze devices, tracking any unusual or unexpected activity")
                    .font(.caption)
                    .foregroundColor(StyleGuide.Typography.captionColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StyleGuide.Spacing.extraLarge)
                
                Spacer()
                
                Button {
                    if appProvider.isPremiumUser {
                        if networkScanner.isScanning || bluetoothManager.isScanning { return }
                        
                        bluetoothManager.startScanning()
                        
                        networkScanner.showAlertAtFinish = true
                        networkScanner.start()
                    } else {
                        withAnimation {
                            appProvider.showPaywall = true
                        }
                    }
                } label: {
                    HStack {
                        if networkScanner.isScanning {
                            ProgressView()
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23)
                        }
                        
                        Text(networkScanner.isScanning ? "Scanning..." : "Scan Network")
                            .font(.body)
                    }
                    .foregroundColor(.white)
                    .padding(StyleGuide.Spacing.medium)
                    .frame(maxWidth: .infinity)
                    .background(Color.customButton)
                    .cornerRadius(17)
                }
                .padding(.horizontal)
                .padding(.bottom, StyleGuide.Spacing.large)
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .standardNavigationStyle(title: "Scan")
        .standardToolbar(
            onRefresh: {
                // TODO: Implement refresh action
            },
            onHexagon: {
                // TODO: Implement hexagon action
            }
        )
    }
}
