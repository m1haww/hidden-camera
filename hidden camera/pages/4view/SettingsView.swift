import SwiftUI
import StoreKit
import SafariServices

struct SettingsView: View {
    @State private var showingShareSheet = false
    @State private var showingTermsOfUse = false
    @State private var showingPrivacyPolicy = false
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: StyleGuide.Spacing.small) {
                if !appProvider.isPremiumUser {
                    Button(action: {
                        withAnimation {
                            appProvider.showPaywall = true
                        }
                    }) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Get Pro")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Unlock all features")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.bottom, 8)
                }
                
                SettingsRow(
                    icon: "doc.text",
                    iconColor: .blue,
                    iconBackgroundColor: Color.blue.opacity(0.2),
                    title: "Terms of Use",
                    action: {
                        if let url = URL(string: "https://www.freeprivacypolicy.com/live/ac37fc73-30fc-4cea-8f2f-2329f400c768") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                SettingsRow(
                    icon: "shield.lefthalf.filled",
                    iconColor: .green,
                    iconBackgroundColor: Color.green.opacity(0.2),
                    title: "Privacy Policy",
                    action: {
                        if let url = URL(string: "https://www.freeprivacypolicy.com/live/d174945f-3722-403b-a62f-c0f165a8ff7a") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                SettingsRow(
                    icon: "star.fill",
                    iconColor: .yellow,
                    iconBackgroundColor: Color.yellow.opacity(0.2),
                    title: "Rate Us",
                    action: {
                        requestReview()
                    }
                )
                
                SettingsRow(
                    icon: "square.and.arrow.up",
                    iconColor: .purple,
                    iconBackgroundColor: Color.purple.opacity(0.2),
                    title: "Share App",
                    action: {
                        showingShareSheet = true
                    }
                )
                .sheet(isPresented: $showingShareSheet) {
                    ShareSheet(items: [
                        "Check out Cam Detector - the best app to detect hidden cameras and protect your privacy! Download it here: https://apps.apple.com/app/idYOURAPPID"
                    ])
                }
                
                Spacer()
            }
            .padding()
        }
        .standardBackground()
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
