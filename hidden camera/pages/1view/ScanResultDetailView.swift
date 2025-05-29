import SwiftUI

struct ScanResultDetailView: View {
    // State variable for the segmented control selection
    @State private var selectedDeviceType: String = "Wi-Fi"
    
    // Placeholder data for devices (you would replace this with actual scan results)
    let devices = [
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: true),
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: false),
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: true),
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: true),
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: false),
        (ip: "192.168.50.272", type: "Wi-Fi", isSecure: false),
        (ip: "192.168.50.272", type: "Bluetooth", isSecure: true),
        (ip: "192.168.50.272", type: "Bluetooth", isSecure: false)
    ]
    
    var body: some View {
        ZStack { // Use ZStack for main background
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set custom background color for the whole view

            VStack(spacing: 20) {
                // Shield/Search Icon
                Image("searchicon") // Use your search icon asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.customButton) // Color the icon
                
                // Descriptive Text
                Text("Scan nearby Wi-Fi and Bluetooth networks to monitor and analyze device activity")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Rescan Button
                Button {
                    // Action for Rescan
                    print("Rescan button tapped!")
                    // You would likely trigger a rescan process here (communicate back to FirstView)
                } label: {
                    Text("Rescan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customButton)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Segmented Control (Wi-Fi/Bluetooth)
                Picker("Device Type", selection: $selectedDeviceType) {
                    Text("Wi-Fi").tag("Wi-Fi")
                    Text("Bluetooth").tag("Bluetooth")
                }
                .pickerStyle(.segmented) // Apply segmented style
                .padding(.horizontal)
                // Apply custom colors to segmented control - requires appearance customization for older iOS
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.customButton)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
                }

                // List of Devices
                // Using ScrollView and ForEach to create the list manually for custom styling
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(devices.filter { $0.type == selectedDeviceType }, id: \.ip) { device in
                            HStack(spacing: 10) {
                                // Device Icon (Wi-Fi/Bluetooth)
                                Image(systemName: device.type == "Wi-Fi" ? "wifi" : "antenna.radiowaves.left.and.right")
                                    .foregroundColor(device.isSecure ? .customButton : .red) // Green for secure, red for insecure
                                
                                Text(device.ip) // IP Address
                                    .foregroundColor(.customText)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right") // Arrow icon
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "1c2021")) // Background color for device row
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal) // Padding for the content inside ScrollView
                    .padding(.bottom) // Add padding at the bottom of the list
                }
            }
            .padding(.top) // Padding for the top of the VStack content
        }
        .navigationTitle("Scanning Result") // Set the navigation bar title
        // Hide the default back button title for a cleaner look
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScanResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Need to embed in a NavigationView to preview the title and back button
        NavigationView {
            ScanResultDetailView()
        }
    }
} 