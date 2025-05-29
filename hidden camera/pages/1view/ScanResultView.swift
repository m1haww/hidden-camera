import SwiftUI

struct ScanResultView: View {
    @Binding var isPresented: Bool // Binding to control the visibility of this view
    // Closure to be called when navigation should occur
    var onNavigateToResult: (() -> Void)?
    
    // You would pass the actual scan results to this view
    var totalDevices: Int = 7 // Placeholder
    var secureDevices: Int = 2 // Placeholder
    var suspiciousDevices: Int = 5 // Placeholder
    
    var body: some View {
        ZStack {
            // Dimming background - similar to a modal overlay in Flutter
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { // Dismiss when tapping outside the alert
                    // isPresented = false // Uncomment this if you want tapping outside to dismiss
                }
            
            // The Alert Dialog Content
            VStack(spacing: 20) {
                // Close Button
                HStack {
                    Spacer()
                    Button {
                        isPresented = false // Dismiss the alert
                    } label: {
                        Image(systemName: "xmark.circle.fill") // Close icon
                            .imageScale(.large)
                            .foregroundColor(.gray)
                    }
                }
                
                // Shield Icon (similar to the scanning icon, but likely a static version)
                Image("searchicon") // Use your search icon asset again
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.customButton) // Assuming it stays customButton color on success
                
                Text("Scanned Successfully!")
                    .font(.title2)
                    .foregroundColor(.customText)
                
                // Total Devices Found
                HStack {
                    Text("Total devices found")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(totalDevices)")
                        .foregroundColor(.customText)
                        .font(.headline)
                }
                .padding()
                .background(Color(hex: "1c2021")) // Background color for this section
                .cornerRadius(8)
                
                // Secure and Suspicious Devices Boxes
                HStack(spacing: 15) {
                    // Secure Devices Box
                    VStack(spacing: 5) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill") // Green check icon
                                .foregroundColor(.green)
                            Spacer()
                            Text("\(secureDevices)")
                                .font(.title2)
                                .foregroundColor(.customText)
                        }
                        Text("Secure Devices")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "1c2021"))
                    .cornerRadius(8)
                    
                    // Suspicious Devices Box
                    VStack(spacing: 5) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill") // Red warning icon
                                .foregroundColor(.red)
                            Spacer()
                            Text("\(suspiciousDevices)")
                                .font(.title2)
                                .foregroundColor(.customText)
                        }
                        Text("Suspicious Devices")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                     .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "1c2021"))
                    .cornerRadius(8)
                }
                
                // Buttons
                Button {
                    // Action for See scanning result
                    isPresented = false // Dismiss the alert
                    onNavigateToResult?() // Call the closure to trigger navigation
                    // You would likely pass scan results data to the detail view here
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
                    // Action for Rescan
                    isPresented = false // Dismiss the alert
                    // Trigger a rescan in FirstView
                    // You might need a way to communicate back to FirstView, e.g., using a closure or a shared observable object
                } label: {
                    Text("Rescan")
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
            .background(Color.customBackground) // Background for the alert content
            .cornerRadius(12) // Rounded corners for the alert box
            .padding(40) // Padding around the alert box to center it and provide space
        }
    }
}

struct ScanResultView_Previews: PreviewProvider {
    static var previews: some View {
        // Need to provide a constant binding for the preview and nil for the closure
        ScanResultView(isPresented: .constant(true), onNavigateToResult: nil)
    }
} 