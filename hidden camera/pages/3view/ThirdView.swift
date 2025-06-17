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
                    description: "Surveillance devices may be concealed in outdoor areas such as trees, fences, or public fixtures. Discover typical hiding methods and how to spot these devices during your inspection",
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
