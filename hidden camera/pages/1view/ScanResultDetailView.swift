import SwiftUI

struct ScanResultDetailView: View {
    @State private var selectedDeviceType: String = "Wi-Fi"
    
    @ObservedObject private var networkScanner = NetworkScanner.shared
    @ObservedObject private var bluetoothManager = BeaconScanner.shared
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("searchicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.customButton)
                
                Text("Scan nearby Wi-Fi and Bluetooth networks to monitor and analyze device activity")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Button {
                    if selectedDeviceType == "Wi-Fi" {
                        networkScanner.showAlertAtFinish = false
                        if networkScanner.isScanning {
                            networkScanner.stop()
                        } else {
                            networkScanner.start()
                        }
                    } else {
                        if bluetoothManager.isScanning {
                            bluetoothManager.stopScanning()
                        } else {
                            bluetoothManager.startScanning()
                        }
                    }
                } label: {
                    HStack {
                        Text((networkScanner.isScanning && selectedDeviceType == "Wi-Fi") || (bluetoothManager.isScanning && selectedDeviceType == "Bluetooth") ? "Stop Scanning" : "Start Scanning")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customButton)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                if (networkScanner.isScanning && selectedDeviceType == "Wi-Fi") || (bluetoothManager.isScanning && selectedDeviceType == "Bluetooth") {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text("Scanning for \(selectedDeviceType) devices...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Picker("Device Type", selection: $selectedDeviceType) {
                    Text("Wi-Fi").tag("Wi-Fi")
                    Text("Bluetooth").tag("Bluetooth")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.customButton)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
                }
                
                if selectedDeviceType == "Wi-Fi" {
                    if networkScanner.connectedDevices.isEmpty {
                        Spacer()
                        
                        VStack(spacing: 15) {
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.gray.opacity(0.9))
                            
                            Text("No Devices Found")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Make sure your WiFi is turned on and devices are nearby.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(20)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                        
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(networkScanner.connectedDevices) { device in
                                    Button(action: {
                                        appProvider.navigationPath.append(.wifiDeviceDetail(device: device))
                                    }) {
                                        HStack(spacing: 10) {
                                            Image(systemName: device.isSecure ? "wifi" : "antenna.radiowaves.left.and.right")
                                                .foregroundColor(device.isSecure ? .customButton : .red)
                                            
                                            Text(device.data.ipAddress)
                                                .foregroundColor(.customText)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(15)
                                        .background(Color(hex: "1c2021"))
                                        .cornerRadius(13)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                } else {
                    if bluetoothManager.peripherals.isEmpty {
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 15) {
                            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.gray.opacity(0.9))
                            
                            Text("No Bluetooth Devices Found")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Make sure your Bluetooth is turned on and devices are nearby.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(20)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                        
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(bluetoothManager.peripherals) { device in
                                    Button(action: {
                                        appProvider.navigationPath.append(.bluetoothDeviceDetail(device: device))
                                    }) {
                                        HStack(spacing: 10) {
                                            Image("bluetooth_green")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 25, height: 25)
                                            
                                            Text(device.name)
                                                .foregroundColor(.customText)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(15)
                                        .background(Color(hex: "1c2021"))
                                        .cornerRadius(13)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Scanning Result")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if networkScanner.isScanning {
                networkScanner.stop()
            }
            
            if bluetoothManager.isScanning {
                bluetoothManager.stopScanning()
            }
        }
    }
}
