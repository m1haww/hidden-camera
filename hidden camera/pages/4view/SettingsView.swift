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
            VStack(spacing: 12) {
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
                
                Button(action: {
                    if let url = URL(string: "https://www.freeprivacypolicy.com/live/ac37fc73-30fc-4cea-8f2f-2329f400c768") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                        }
                        
                        Text("Terms of Use")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                
                Button(action: {
                    if let url = URL(string: "https://www.freeprivacypolicy.com/live/d174945f-3722-403b-a62f-c0f165a8ff7a") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "shield.lefthalf.filled")
                                .foregroundColor(.green)
                                .font(.system(size: 18))
                        }
                        
                        Text("Privacy Policy")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                
                Button(action: {
                    requestReview()
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 18))
                        }
                        
                        Text("Rate Us")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.purple)
                                .font(.system(size: 18))
                        }
                        
                        Text("Share App")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                .sheet(isPresented: $showingShareSheet) {
                    ShareSheet(items: [
                        "Check out Cam Detector - the best app to detect hidden cameras and protect your privacy! Download it here: https://apps.apple.com/app/idYOURAPPID"
                    ])
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.customBackground.ignoresSafeArea())
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
