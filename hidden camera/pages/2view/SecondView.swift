import SwiftUI

struct SecondView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ZStack {
            StyleGuide.Navigation.backgroundColor.edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: StyleGuide.Spacing.large) {
                    FeatureCard(
                        icon: "scope",
                        iconColor: .customButton,
                        title: "Blinking Devices Scanner",
                        description: "Choose a filter and reposition to locate unknown flashing devices",
                        isPremium: true,
                        action: {
                            if appProvider.isPremiumUser {
                                appProvider.navigationPath.append(NavigationDestination.blinkingScanner)
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
                    )

                    FeatureCard(
                        icon: "compass.drawing",
                        iconColor: .customButton,
                        title: "Compass Visual",
                        description: "Electronic devices may emit normal electromagnetic signals.",
                        isPremium: true,
                        action: {
                            if appProvider.isPremiumUser {
                                appProvider.navigationPath.append(NavigationDestination.compassVisualDetail)
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
                    )
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .standardNavigationStyle(title: "Tools")
        .standardToolbar(
            onRefresh: {
                // TODO: Implement refresh action
            },
            onHexagon: {
                // TODO: Implement hexagon action
            }
        )
    }
}
