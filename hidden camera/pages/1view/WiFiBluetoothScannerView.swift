import SwiftUI

struct WiFiBluetoothScannerView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @StateObject private var networkScanner = NetworkScanner.shared
    @StateObject private var bluetoothManager = BeaconScanner.shared
    @StateObject private var deviceInfoProvider = DeviceInfoProvider.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            StyleGuide.Navigation.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
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
                .padding(.horizontal, 25)
                .padding(.top, 30)
                
                Spacer()
                
                VStack(spacing: 30) {
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
                            .foregroundColor(networkScanner.isScanning ? .customButton : (networkScanner.progress >= 1.0 ? .customButton : .gray))
                    }
                    
                    if networkScanner.isScanning {
                        Text("\(Int(networkScanner.progress * 100))%")
                            .font(.title2)
                            .foregroundColor(.customText)
                    }
                    
                    Text("Scan local Wi-Fi and Bluetooth for unusual device activity")
                        .font(.system(size: 16))
                        .foregroundColor(StyleGuide.Typography.captionColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, StyleGuide.Spacing.extraLarge)
                }
                
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
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.system(size: 20))
                        }
                        
                        Text(networkScanner.isScanning ? "Scanning..." : "Scan Network")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.customButton)
                    .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Wi-Fi & Bluetooth Scanner")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.customBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
        .task {
            await deviceInfoProvider.fetchIPInfo()
        }
    }
}
