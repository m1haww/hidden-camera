import SwiftUI

struct FirstView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    @State private var lastCompletedScanType: String = "Wi-Fi"
    
    @StateObject private var deviceInfoProvider = DeviceInfoProvider.shared
    @StateObject private var networkScanner = NetworkScanner.shared
    @StateObject private var bluetoothManager = BeaconScanner.shared
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Connection Type")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(deviceInfoProvider.geoIPInfo?.mobile ?? false ? "Cellular" : "Wi-Fi")
                            .foregroundColor(.customText)
                    }
                    Divider()
                        .background(Color.gray.opacity(0.5))
                    HStack {
                        Text("IP Address")
                            .foregroundColor(.gray)
                        Spacer()
                        
                        if let error = deviceInfoProvider.error {
                            Text("Error: \(error.localizedDescription)")
                                .foregroundColor(.red)
                        } else if let ipInfo = deviceInfoProvider.geoIPInfo?.query {
                            Text("\(ipInfo)")
                        } else {
                            Text("No IP Info Available")
                        }
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
                .background(Color(hex: "1c2021"))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                
                Spacer()
                
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.customBackground)
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .trim(from: 0.0, to: networkScanner.progress)
                            .stroke(Color.customButton, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.5), value: networkScanner.progress)
                        
                        Image("searchicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
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
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                Button {
                    if networkScanner.isScanning || bluetoothManager.isScanning { return }
                    
                    bluetoothManager.startScanning()
                    
                    networkScanner.showAlertAtFinish = true
                    networkScanner.start()
                } label: {
                    HStack {
                        if networkScanner.isScanning {
                            ProgressView()
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
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color.customButton)
                    .cornerRadius(17)
                }
                .padding(.horizontal)
                .padding(.bottom, 25)
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .navigationTitle("Scan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.customButton)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "hexagon.fill")
                        .foregroundColor(.customButton)
                }
            }
        }
    }
}
