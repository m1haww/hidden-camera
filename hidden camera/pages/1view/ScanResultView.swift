import SwiftUI

struct ScanResultView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var networkScanner = NetworkScanner.shared
    
    let scannedDeviceType: String
    
    @State var secureDevices: Int = 0
    @State var suspiciousDevices: Int = 0
    @State var isLoading = true
    
    var body: some View {
        if isLoading {
            ProgressView()
                .foregroundStyle(.white)
                .onAppear {
                    for device in networkScanner.connectedDevices {
                        if device.isSecure {
                            secureDevices += 1
                        } else {
                            suspiciousDevices += 1
                        }
                    }
                    isLoading = false
                }
        } else {
            ZStack {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        appProvider.showAlert = false
                        networkScanner.progress = 0
                    }
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button {
                            appProvider.showAlert = false
                        networkScanner.progress = 0
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Image("searchicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.customButton)
                    
                    Text("Scanned Successfully!")
                        .font(.title2)
                        .foregroundColor(.customText)
                    
                    HStack {
                        Text("Total devices found")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(networkScanner.connectedDevices.count)")
                            .foregroundColor(.customText)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(hex: "1c2021"))
                    .cornerRadius(8)
                    
                    HStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Spacer()
                                Text("\(secureDevices)")
                                    .font(.title2)
                                    .foregroundColor(.customText)
                            }
                            Text("Secure\nDevices")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "1c2021"))
                        .cornerRadius(14)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                Spacer()
                                Text("\(suspiciousDevices)")
                                    .font(.title2)
                                    .foregroundColor(.customText)
                            }
                            Text("Suspicious\nDevices")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "1c2021"))
                        .cornerRadius(14)
                    }
                    
                    Button {
                        appProvider.showAlert = false
                        networkScanner.progress = 0
                        appProvider.navigationPath.append(NavigationDestination.scanResultDetail)
                    } label: {
                        Text("See scanning result")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color.customButton)
                            .cornerRadius(25)
                    }
                    
                    Button {
                        appProvider.showAlert = false
                        // Ensure progress is reset
                        networkScanner.progress = 0
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.customButton)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.customButton, lineWidth: 2)
                            )
                    }
                }
                .padding(25)
                .background(Color.customBackground)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
            }
        }
    }
}
