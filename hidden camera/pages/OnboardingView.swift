import SwiftUI
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
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.accentColor)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        appProvider.completeOnboarding()
                        withAnimation {
                            appProvider.showOnboardingPaywall = true
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 50)
                .padding(.trailing, 10)
                
                Spacer()
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
                Text("Analyze Your\nNetwork Activity")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Stay fully informed about nearby wireless activity to maintain complete control over digital space")
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
                .shadow(color: .yellow.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: .yellow.opacity(0.2), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 20) {
                Text("Scan & Secure Your Wireless Environment")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Real-time Wi-Fi & Bluetooth scanning uncovers unknown devices and boosts your privacy awareness")
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
                .shadow(color: .yellow.opacity(0.3), radius: 20, x: 0, y: 10)
                .shadow(color: .yellow.opacity(0.2), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 20) {
                Text("Protect Your Privacy")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Monitor nearby signals and connected smart devices to maintain a secure, private, and trusted environment")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
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
