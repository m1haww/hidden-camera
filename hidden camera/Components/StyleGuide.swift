import SwiftUI

struct StyleGuide {
    struct Cards {
        static let backgroundColor = Color(hex: "1c2021")
        static let cornerRadius: CGFloat = 12
        static let iconSize: CGFloat = 40
        static let spacing: CGFloat = 10
        static let padding: CGFloat = 16
    }
    
    struct Settings {
        static let rowCornerRadius: CGFloat = 16
        static let rowBackgroundOpacity: Double = 0.1
        static let iconSize: CGFloat = 40
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 14
    }
    
    struct Navigation {
        static let backgroundColor = Color.customBackground
        static let toolbarIconColor = Color.customButton
    }
    
    struct Scanning {
        static let progressCircleSize: CGFloat = 160
        static let progressLineWidth: CGFloat = 8
        static let iconSize: CGFloat = 65
    }
    
    struct Typography {
        static let captionColor = Color.gray
        static let titleColor = Color.customText
    }
    
    struct Spacing {
        static let small: CGFloat = 10
        static let medium: CGFloat = 15
        static let large: CGFloat = 25
        static let extraLarge: CGFloat = 30
    }
}

extension View {
    func standardBackground() -> some View {
        self
            .background(Color.customBackground.ignoresSafeArea())
    }
    
    func standardNavigationStyle(title: String) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func checkPremiumAccess(appProvider: AppProvider, action: @escaping () -> Void) {
        if appProvider.isPremiumUser {
            action()
        } else {
            withAnimation {
                if appProvider.hasExpiredTrial {
                    appProvider.showPaywall = true
                } else {
                    appProvider.showOnboardingPaywall = true
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(StyleGuide.Typography.captionColor)
            
            Spacer()
            
            Text(value)
                .foregroundColor(StyleGuide.Typography.titleColor)
        }
    }
}
