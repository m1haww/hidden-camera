import SwiftUI

@main
struct hidden_cameraApp: App {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some Scene {
        WindowGroup {
            if appProvider.showSplashScreen {
                SplashScreenView()
            } else {
                ContentView()
            }
        }
    }
}
