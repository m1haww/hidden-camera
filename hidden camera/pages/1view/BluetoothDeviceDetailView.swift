import SwiftUI
import CoreBluetooth

struct BluetoothDeviceDetailView: View {
    let device: Peripheral
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 30) {
                Image("bluetooth_green")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.customButton)
                
                VStack(alignment: .leading, spacing: 18) {
                    DeviceDetailRow(icon: "wifi", label: "Connection Type", value: "Wi-Fi")
                    DeviceDetailRow(icon: "globe", label: "UUID", value: device.id.uuidString)
                    DeviceDetailRow(icon: "lock", label: "RSSI", value: "\(device.rssi)")
                    DeviceDetailRow(icon: "rectangle.and.pencil.and.ellipsis", label: "Model", value: device.name)
                }
                .padding()
                .background(Color(hex: "1c2021"))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeviceDetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.customButton)
                .frame(width: 20)
            
            Text(label)
                .foregroundColor(.customText)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.gray)
        }
    }
} 
