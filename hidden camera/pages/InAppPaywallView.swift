import SwiftUI
import RevenueCat
import RevenueCatUI

struct InAppPaywallView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @State private var selectedPackage: Package? = nil
    @State private var availablePackages: [Package] = []
    @State private var isLoading = true
    @State private var freeTrialEnabled = false
    @State private var isTrialEligible = false
    @State private var eligibilityChecked = false
    @State private var hasTrialProducts = false
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ZStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 80))
                    .foregroundColor(Color.accentColor.opacity(0.08))
                    .rotationEffect(.degrees(-15))
                    .offset(x: -120, y: -280)
                    .blur(radius: 3)
                
                Image(systemName: "wifi")
                    .font(.system(size: 60))
                    .foregroundColor(Color.accentColor.opacity(0.06))
                    .rotationEffect(.degrees(20))
                    .offset(x: 140, y: -250)
                    .blur(radius: 2)
                
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 50))
                    .foregroundColor(Color.accentColor.opacity(0.05))
                    .rotationEffect(.degrees(-10))
                    .offset(x: -130, y: 50)
                    .blur(radius: 2)
                
                Image(systemName: "sensor.tag.radiowaves.forward")
                    .font(.system(size: 70))
                    .foregroundColor(Color.accentColor.opacity(0.07))
                    .rotationEffect(.degrees(25))
                    .offset(x: 150, y: 100)
                    .blur(radius: 3)
                
                Image(systemName: "wave.3.left")
                    .font(.system(size: 45))
                    .foregroundColor(Color.accentColor.opacity(0.06))
                    .rotationEffect(.degrees(15))
                    .offset(x: -140, y: 280)
                    .blur(radius: 2)
                
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 55))
                    .foregroundColor(Color.accentColor.opacity(0.05))
                    .rotationEffect(.degrees(-20))
                    .offset(x: 130, y: 320)
                    .blur(radius: 3)
            }
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button(action: {
                            appProvider.showPaywall = false
                        }) {
                           Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        restore()
                    }) {
                        Text("Restore")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.top, 60)
                
                Spacer().frame(height: 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .symbolRenderingMode(.hierarchical)
                }
                
                Spacer().frame(height: 30)
                
                Text("Start To Continue\nWith Full Access")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 30)
                
                VStack(spacing: 0) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical, 50)
                    } else {
                        // Determine which package IDs to use based on trial availability
                        let useTrialPackages = freeTrialEnabled && hasTrialProducts && isTrialEligible
                        let weeklyId = useTrialPackages ? "weekly.trial" : "weekly"
                        let monthlyId = useTrialPackages ? "monthly.trial" : "monthly"
                        let yearlyId = useTrialPackages ? "yearly.trial" : "yearly"
                        
                        if let weeklyPackage = availablePackages.first(where: { $0.identifier == weeklyId }) {
                            PackageOptionView(
                                package: weeklyPackage,
                                isSelected: selectedPackage?.identifier == weeklyPackage.identifier,
                                freeTrialEnabled: freeTrialEnabled && hasTrialProducts,
                                isTrialEligible: isTrialEligible
                            ) {
                                selectedPackage = weeklyPackage
                            }
                        }
                        
                        if let monthlyPackage = availablePackages.first(where: { $0.identifier == monthlyId }) {
                            PackageOptionView(
                                package: monthlyPackage,
                                isSelected: selectedPackage?.identifier == monthlyPackage.identifier,
                                freeTrialEnabled: freeTrialEnabled && hasTrialProducts,
                                isTrialEligible: isTrialEligible
                            ) {
                                selectedPackage = monthlyPackage
                            }
                        }
                        
                        if let yearlyPackage = availablePackages.first(where: { $0.identifier == yearlyId }) {
                            PackageOptionView(
                                package: yearlyPackage,
                                isSelected: selectedPackage?.identifier == yearlyPackage.identifier,
                                freeTrialEnabled: freeTrialEnabled && hasTrialProducts,
                                isTrialEligible: isTrialEligible
                            ) {
                                selectedPackage = yearlyPackage
                            }
                        }
                        
                        if isTrialEligible && hasTrialProducts {
                            HStack {
                                Text("Free Trial")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $freeTrialEnabled)
                                    .tint(Color.accentColor)
                                    .disabled(!isTrialEligible || !hasTrialProducts)
                                    .onChange(of: freeTrialEnabled) { _ in
                                        updateSelectedPackage()
                                    }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 18)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
                
                Spacer(minLength: 20)
                
                // CTA Button
                VStack(spacing: 20) {
                    Button(action: {
                        purchase()
                    }) {
                        Text("Subscribe")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.accentColor)
                            )
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    HStack(spacing: 40) {
                        Button("Privacy") {
                            if let url = URL(string: "https://www.freeprivacypolicy.com/live/d174945f-3722-403b-a62f-c0f165a8ff7a") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        
                        Button("Terms") {
                            if let url = URL(string: "https://www.freeprivacypolicy.com/live/ac37fc73-30fc-4cea-8f2f-2329f400c768") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            loadOfferings()
        }
    }
    
    private func loadOfferings() {
        checkTrialEligibility()
        
        Purchases.shared.getOfferings { offerings, error in
            if let packages = offerings?.all["in-app"]?.availablePackages {
                self.availablePackages = packages
                
                self.hasTrialProducts = packages.contains { package in
                    if package.identifier.contains(".trial") {
                        if let product = package.storeProduct.sk1Product {
                            return product.introductoryPrice != nil
                        } else if let product = package.storeProduct.sk2Product {
                            return product.subscription?.introductoryOffer != nil
                        }
                    }
                    return false
                }
                
                if !self.hasTrialProducts {
                    self.freeTrialEnabled = false
                }
                
                updateSelectedPackage()
            }
            self.isLoading = false
        }
    }
    
    private func checkTrialEligibility() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                let hasAnyPurchaseHistory = !customerInfo.allPurchasedProductIdentifiers.isEmpty
                let hasAnySubscriptionHistory = !customerInfo.activeSubscriptions.isEmpty || 
                                               customerInfo.latestExpirationDate != nil
                
                self.isTrialEligible = !hasAnyPurchaseHistory && !hasAnySubscriptionHistory
                
                if !self.isTrialEligible {
                    self.freeTrialEnabled = false
                } else if self.hasTrialProducts {
                    self.freeTrialEnabled = true
                } else {
                    self.freeTrialEnabled = false
                }
                
                self.eligibilityChecked = true
                updateSelectedPackage()
            }
        }
    }
    
    private func updateSelectedPackage() {
        let useTrialPackages = freeTrialEnabled && hasTrialProducts && isTrialEligible
        
        if let currentSelected = selectedPackage {
            let currentType = getPackageType(from: currentSelected.identifier)
            let newIdentifier = useTrialPackages ? "\(currentType).trial" : currentType
            
            // Try to find the new package, fallback to non-trial if trial doesn't exist
            if let newPackage = availablePackages.first(where: { $0.identifier == newIdentifier }) {
                selectedPackage = newPackage
            } else if useTrialPackages {
                // Fallback to non-trial version if trial package doesn't exist
                selectedPackage = availablePackages.first { $0.identifier == currentType }
            }
        } else {
            // Default selection
            let weeklyId = useTrialPackages ? "weekly.trial" : "weekly"
            selectedPackage = availablePackages.first { $0.identifier == weeklyId }
                ?? availablePackages.first { $0.identifier == "weekly" }
                ?? availablePackages.first
        }
    }
    
    private func getPackageType(from identifier: String) -> String {
        if identifier.contains("weekly") {
            return "weekly"
        } else if identifier.contains("monthly") {
            return "monthly"
        } else if identifier.contains("yearly") {
            return "yearly"
        }
        return "weekly"
    }
    
    private func purchase() {
        guard let package = selectedPackage ?? availablePackages.first else { return }
        
        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
            if customerInfo?.entitlements.all["pro"]?.isActive == true {
                appProvider.isPremiumUser = true
                appProvider.showPaywall = false
            }
        }
    }
    
    private func restore() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if customerInfo?.entitlements.all["pro"]?.isActive == true {
                appProvider.isPremiumUser = true
                appProvider.showPaywall = false
            }
        }
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct PackageOptionView: View {
    let package: Package
    let isSelected: Bool
    let freeTrialEnabled: Bool
    let isTrialEligible: Bool
    let action: () -> Void
    
    var hasIntroOffer: Bool {
        if let product = package.storeProduct.sk1Product {
            return product.introductoryPrice != nil
        } else if let product = package.storeProduct.sk2Product {
            return product.subscription?.introductoryOffer != nil
        }
        return false
    }
    
    var periodText: String {
        if package.identifier.contains("weekly") {
            return "Week"
        } else if package.identifier.contains("monthly") {
            return "Month"
        } else if package.identifier.contains("yearly") {
            return "Year"
        }
        return ""
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                HStack(spacing: 16) {
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 26, height: 26)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.accentColor)
                        } else {
                            Circle()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                                .frame(width: 26, height: 26)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(periodText)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(freeTrialEnabled && isTrialEligible && hasIntroOffer ? "3-Days Free Trial" : "Get a Plan")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.leading, 24)
                
                Spacer()
                
                Text(package.localizedPriceString)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.trailing, 24)
            }
            .frame(height: 72)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.accentColor : Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

