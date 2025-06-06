import SwiftUI
import RevenueCat
import RevenueCatUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: AppProvider.shared.revenueCatApiKey)
        
        AppProvider.shared.loadConfige()
        
        return true
    }
}

@main
struct hidden_cameraApp: App {
    @ObservedObject private var appProvider = AppProvider.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if appProvider.showSplashScreen {
                SplashScreenView()
            } else if !appProvider.isOnboardingComplete {
                OnboardingView()
            } else {
                ContentView()
                    .fullScreenCover(isPresented: $appProvider.showOnboardingPaywall) {
                        OnboardingPaywallPage()
                    }
                    .fullScreenCover(isPresented: $appProvider.showPaywall) {
                        InAppPaywallView()
                    }
            }
        }
    }
}
