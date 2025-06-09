import SwiftUI

struct SplashScreenView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var deviceInfoProvider = DeviceInfoProvider.shared
    @State private var isAnimating = false
    @State private var iconScale: CGFloat = 0.3
    @State private var iconOpacity: Double = 0
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity: Double = 0
    @State private var pulseAnimation: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                    .shadow(color: .white.opacity(0.5), radius: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .scaleEffect(pulseAnimation)
                            .opacity(2 - pulseAnimation)
                    )
                
                VStack(spacing: 10) {
                    Text("MTrak")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Cam Detector")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                textOffset = 0
                textOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                pulseAnimation = 1.5
            }
            
            isAnimating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    iconOpacity = 0
                    textOpacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appProvider.showSplashScreen = false
                }
            }
        }
        .task {
            await deviceInfoProvider.fetchIPInfo()
        }
    }
}
