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
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        appProvider.showAlert = false
                    }
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button {
                            appProvider.showAlert = false
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
                                Image("shield")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
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
                                Image("warning")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
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
                        appProvider.navigationPath.append(NavigationDestination.scanResultDetail)
                    } label: {
                        Text("See scanning result")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customButton)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        appProvider.showAlert = false
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.customButton)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.customButton, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(Color.customBackground)
                .cornerRadius(20)
                .padding(25)
            }
        }
    }
}
