import SwiftUI

struct ThirdView: View {
    @State private var showIndoorGuide = false
    @State private var showOutdoorGuide = false
    
    var body: some View {
        ZStack {
            StyleGuide.Navigation.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: StyleGuide.Spacing.large) {
                FeatureCard(
                    icon: "chair.fill",
                    iconColor: .customButton,
                    title: "Indoor Places",
                    description: "Learn about common indoor objects that may contain small electronic components and explore general tips for environmental awareness.",
                    isPremium: false,
                    action: {
                        showIndoorGuide = true
                    }
                )
                
                FeatureCard(
                    icon: "tree.fill",
                    iconColor: .customButton,
                    title: "Outdoor Places",
                    description: "Explore outdoor spaces including landscaping, furniture, and architectural features. Learn about materials, maintenance, and design elements commonly found in exterior environments.",
                    isPremium: false,
                    action: {
                        showOutdoorGuide = true
                    }
                )
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .standardNavigationStyle(title: "Guides")
        .standardToolbar(
            onRefresh: {
                // TODO: Implement refresh action
            },
            onHexagon: {
                // TODO: Implement hexagon action
            }
        )
        .sheet(isPresented: $showIndoorGuide) {
            NavigationView {
                IndoorGuideDetailView()
            }
        }
        .sheet(isPresented: $showOutdoorGuide) {
            NavigationView {
                OutdoorGuideDetailView()
            }
        }
    }
}
