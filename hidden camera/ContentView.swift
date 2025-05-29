//
//  ContentView.swift
//  hidden camera
//
//  Created by Mihail Ozun on 29.05.2025.
//

import SwiftUI

struct ContentView: View {
    // State variable to control the presentation of the scan result alert (moved from FirstView)
    @State private var showAlert: Bool = false

    var body: some View {
        TabView {
            NavigationView {
                // Pass showAlert down to FirstView as a binding
                FirstView(showAlert: $showAlert)
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
        // Applying accent color to selected tab item
        // Note: Styling TabView appearance can be limited and may require
        // using .accentColor or potentially other workarounds for older iOS versions.
        .accentColor(.customButton)
        // Apply blur to the entire TabView when the alert is shown
        .blur(radius: showAlert ? 10 : 0)
        // Present the custom alert as an overlay on the ContentView
        .overlay(
            Group {
                if showAlert {
                    ScanResultView(isPresented: $showAlert); // ScanResultView still uses the binding
                }
            }
        )
    }
}

#Preview {
    ContentView()
}

