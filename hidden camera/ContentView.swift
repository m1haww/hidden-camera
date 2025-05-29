//
//  ContentView.swift
//  hidden camera
//
//  Created by Mihail Ozun on 29.05.2025.
//

import SwiftUI

// Define navigation destinations for the Scan tab (should be accessible where needed)
// Moved to AppNavigation.swift
// enum ScanNavigationDestination: Hashable {
//     case scanResultDetail
// }

struct ContentView: View {
    // State variable to control the presentation of the scan result alert
    @State private var showAlert: Bool = false
    // State variable to manage the navigation path for the Scan tab
    @State private var scanNavigationPath = NavigationPath()

    var body: some View {
        ZStack {
            TabView {
                NavigationStack(path: $scanNavigationPath) { // Use NavigationStack for the first tab, bound to the path
                    // Pass showAlert and the navigation path down to FirstView
                    FirstView(showAlert: $showAlert, navigationPath: $scanNavigationPath)
                }
                    .tabItem {
                        Label("Scan", image: "polygon")
                    }
                
                SecondView()
                    .tabItem {
                        Label("Instruments", image: "instrument")
                    }
                
                ThirdView()
                    .tabItem {
                        Label("Guides", image: "guide")
                    }
            }
            .accentColor(.customButton)
            .blur(radius: showAlert ? 10 : 0)
            
            if showAlert {
                ScanResultView(isPresented: $showAlert, navigationPath: $scanNavigationPath, scannedDeviceType: "Test")
            }
        }
    }
}

#Preview {
    ContentView()
}

