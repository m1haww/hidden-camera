import SwiftUI

struct LanDeviceDetailView: View {
    @ObservedObject var device: WiFiDevice
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: device.isSecure ? "wifi" : "wifi.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(device.isSecure ? .customButton : .red)
                    .padding(.top)
                
                Text(device.isSecure ? "Secure Connection" : "Suspicious Connection")
                    .font(.title2)
                    .foregroundColor(device.isSecure ? .customButton : .red)
                
                if !device.isSecure {
                    Button {
                        device.isSecure = true
                    } label: {
                        Label("Mark as secure", systemImage: "checkmark.shield.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customButton)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(.gray)
                        Text("Connection Type")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Wi-Fi")
                            .foregroundColor(.customText)
                    }
                    Divider().background(Color.gray.opacity(0.5))
                    
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                        Text("IP Address")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(device.ipAddress)
                            .foregroundColor(.customText)
                    }
                    Divider().background(Color.gray.opacity(0.5))
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        Text("Mac Address")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(device.macAddress)
                            .foregroundColor(.customText)
                    }
                    Divider().background(Color.gray.opacity(0.5))
                    
                    HStack {
                        Image(systemName: "square")
                            .foregroundColor(.gray)
                        Text("Model")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(device.brand.isEmpty ? "Unknown" : device.brand)
                            .foregroundColor(.customText)
                    }
                }
                .padding()
                .background(Color(hex: "1c2021"))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(device.name)
                    .foregroundColor(.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
