import SwiftUI
import StoreKit
import RevenueCatUI
import RevenueCat

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 25) {
                    PageIndicator(currentPage: currentPage, totalPages: 3)
                        .padding(.top, 20)
                    
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            appProvider.completeOnboarding()
                            
                            withAnimation {
                                appProvider.showOnboardingPaywall = true
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.accentColor)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear(perform: {
            UIScrollView.appearance().isScrollEnabled = false
        })
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image("eye")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: .white.opacity(0.2), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 20) {
                Text("Detect Hidden Cameras")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Protect your privacy with advanced detection technology that finds hidden cameras in any environment")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image("wifi")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: .blue.opacity(0.2), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 20) {
                Text("Multiple Detection Methods")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Scan WiFi networks, Bluetooth devices, and use magnetic field detection to find any hidden recording device")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image("shield")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: .green.opacity(0.2), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 20) {
                Text("Stay Safe Everywhere")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Whether in hotels, Airbnbs, or public spaces, ensure your privacy is protected with real-time scanning")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .onAppear {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
    }
}

struct OnboardingPaywallPage: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        PaywallView()
            .onPurchaseCompleted { _ in
                appProvider.isPremiumUser = true
                withAnimation {
                    appProvider.showOnboardingPaywall = false
                }
            }
            .onRestoreCompleted { _ in
                appProvider.isPremiumUser = true
                withAnimation {
                    appProvider.showOnboardingPaywall = false
                }
            }
    }
}
