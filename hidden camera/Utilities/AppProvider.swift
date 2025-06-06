import Foundation
import SwiftUI
import RevenueCat

final class AppProvider: ObservableObject {
    static let shared = AppProvider()
    
    let revenueCatApiKey: String = "appl_XprviSRgaxAIzJMEPbaHBJsuLln"
    
    @Published var navigationPath: [NavigationDestination] = []
    @Published var showAlert: Bool = false
    
    @Published var showOnboardingPaywall: Bool = false
    @Published var showPaywall: Bool = false
    
    @Published var showSplashScreen: Bool = true
    @Published var isOnboardingComplete: Bool = false
    @Published var isPremiumUser: Bool = false
    
    func loadConfige() {
        loadOnboardingStatus()
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isPremiumUser = customerInfo?.entitlements.all["pro"]?.isActive == true
        }
    }
    
    func completeOnboarding() {
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")
    }
    
    private func loadOnboardingStatus() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
    }
}
