import SwiftUI
import hidden_camera // Import the module containing ScanNavigationDestination

// Define navigation destinations for the Scan tab
// Moved to AppNavigation.swift
// enum ScanNavigationDestination: Hashable {
//     case scanResultDetail
//     case scanningProgress(deviceType: String)
// }

struct FirstView: View {
    // State variable to hold the scan percentage (0.0 to 1.0)
    @State private var scanProgress: Double = 0.0 // This will control the progress circle
    // State variable to track if scanning is active
    @State private var isScanningActive: Bool = false
    // Binding to control the presentation of the scan result alert (now owned by ContentView)
    @Binding var showAlert: Bool
    // Binding to the navigation path managed by the parent view (ContentView)
    @Binding var navigationPath: NavigationPath
    // State variable to hold the type of scan that was just completed
    @State private var lastCompletedScanType: String = "Wi-Fi" // Default or initial type
    
    var body: some View {
        // The NavigationStack is now in ContentView
        // We no longer need a NavigationLink here
        
        ZStack { // Use ZStack for main background
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set custom background color for the whole view

            VStack(spacing: 25) { // Slightly increased spacing
                
                // Connection Info Section/
                VStack(alignment: .leading) {
                    HStack {
                        Text("Connection Type")
                            .foregroundColor(.gray)
                        Spacer()
                        // This text could dynamically show the type being scanned
                        Text("Wi-Fi") // Assuming Wi-Fi for now based on UI
                            .foregroundColor(.customText)
                    }
                    Divider() // A thin line separator
                        .background(Color.gray.opacity(0.5))
                    HStack {
                        Text("IP Address")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("192.168.50.424") // Replace with dynamic IP if needed
                            .foregroundColor(.customText)
                    }
                }
                .padding(.vertical, 15) // Adjusted vertical padding
                .padding(.horizontal)
                .background(Color(hex: "1c2021")) // Slightly different background color for section
                .cornerRadius(8) // Slightly smaller corner radius
                
                // Circular Scanning Element with Progress
                VStack(spacing: 15) {
                    ZStack {
                        // Inner Circle Background (using customBackground)
                        Circle()
                            .fill(Color.customBackground)
                            .frame(width: 160, height: 160)
                        
                        // Background Circle Stroke (unfilled part)
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                            .frame(width: 160, height: 160)
                        
                        // Progress Circle Stroke (filled part)
                        Circle()
                            .trim(from: 0.0, to: scanProgress) // .trim controls how much of the circle is drawn
                            .stroke(Color.customButton, style: StrokeStyle(lineWidth: 8, lineCap: .round)) // Colored stroke with rounded ends
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90)) // Start the progress from the top
                            .animation(.linear(duration: 0.5), value: scanProgress) // Add animation
                        
                        // Your custom search icon image
                        Image("searchicon") // <-- Using your custom image asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65) // Adjust size as needed
                            // Conditionally apply foreground color based on scanning state and completion
                            .foregroundColor(isScanningActive ? Color(hex: "29B684") : (scanProgress >= 1.0 ? .customButton : .gray))
                    }
                    
                    Text("\(Int(scanProgress * 100))%") // Display percentage
                        .font(.title2)
                        .foregroundColor(.customText)
                }
                
                // Descriptive Text Block
                Text("Scan nearby Wi-Fi and Bluetooth networks to monitor and analyze devices, tracking any unusual or unexpected activity")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                // Scan Networks Button
                Button {
                    // Action for the button tap
                    print("Scan Networks button tapped!")
                    
                    if isScanningActive {
                         // If already scanning, stop it
                         isScanningActive = false
                         scanProgress = 0.0 // Reset progress if stopping early to go back to gray
                         // Invalidate any ongoing timers or scan processes here
                    } else {
                         // If not scanning, start it
                         isScanningActive = true
                         scanProgress = 0.0 // Ensure progress starts from 0
                         
                         // Simulate setting the scanned type - in a real app, this would come from scan results
                         self.lastCompletedScanType = "Wi-Fi" // Assuming Wi-Fi for this button's primary action

                         // In a real app, start your scan process here and update scanProgress periodically
                         // For demo, we'll simulate progress update:
                         Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                             if self.isScanningActive { // Check if scanning is still active
                                 self.scanProgress += 0.01 // Increment progress
                                 if self.scanProgress >= 1.0 {
                                     self.scanProgress = 1.0
                                     self.isScanningActive = false // Mark scanning as finished
                                     timer.invalidate() // Stop the timer
                                     self.showAlert = true // Show the alert when scan is complete
                                 }
                             } else {
                                  timer.invalidate() // Stop timer if scanning was cancelled
                             }
                         }
                    }
                    
                } label: {
                    Text("Scan Networks")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customButton)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
            }
            .padding(.top)
        }
        .navigationTitle("Scan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Action for refresh button
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.customButton)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Action for the hexagon button
                } label: {
                    Image(systemName: "hexagon.fill")
                        .foregroundColor(.customButton)
                }
            }
        }
        // Present the custom alert as an overlay
//        .overlay(
//            Group {
//                if showAlert {
//                    // Present ScanResultView from here and pass the scanned device type
////                    ScanResultView(isPresented: $showAlert, navigationPath: $navigationPath, scannedDeviceType: lastCompletedScanType)
//                    Text("Hell world")
//                }
//            }
//        )
        // Define the navigation destination using the binding
        .navigationDestination(for: ScanNavigationDestination.self) { destination in
            switch destination {
            case .scanResultDetail:
                ScanResultDetailView()
            case .scanningProgress(let deviceType):
                ScanningProgressView(deviceType: deviceType)
            }
        }
    }
}

#Preview {
    // Need to provide a constant binding for showAlert and navigationPath for the preview and wrap in NavigationStack
    NavigationStack {
        FirstView(showAlert: .constant(false), navigationPath: .constant(NavigationPath()))
    }
}
