import Foundation
import SwiftUI

final class AppProvider: ObservableObject {
    static let shared = AppProvider()
    
    private init() {}
    
    @Published var navigationPath: [NavigationDestination] = []
    @Published var showAlert: Bool = false
    
    @Published var showSplashScreen: Bool = true
}
