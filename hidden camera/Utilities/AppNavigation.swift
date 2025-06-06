import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case scanResultDetail
    case wifiDeviceDetail(device: WiFiDevice)
    case bluetoothDeviceDetail(device: Peripheral)
    case blinkingScanner
    case compassVisualDetail
}
