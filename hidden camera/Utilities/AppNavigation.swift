import Foundation
import SwiftUI

// Define navigation destinations for the Scan tab
enum ScanNavigationDestination: Hashable {
    case scanResultDetail
    case scanningProgress(deviceType: String)
}
