import SwiftUI

struct SplashScreenView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @ObservedObject private var deviceInfoProvider = DeviceInfoProvider.shared
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            Text("Hidden Camera")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                appProvider.showSplashScreen = false
            }
        }
        .task {
            await deviceInfoProvider.fetchIPInfo()
        }
    }
}
