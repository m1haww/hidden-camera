import SwiftUI

struct FirstView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    @StateObject private var scanHistoryManager = ScanHistoryManager.shared
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Scanners and search tools")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            ToolCard(
                                title: "Wi-Fi &\nBluetooth",
                                icon: "magnifyingglass",
                                backgroundColor: Color(hex: "90b819"),
                                action: {
                                    if appProvider.isPremiumUser {
                                        appProvider.navigationPath.append(NavigationDestination.wifiBluetoothScanner)
                                    } else {
                                        if appProvider.hasExpiredTrial {
                                            appProvider.showPaywall = true
                                        } else {
                                            appProvider.showOnboardingPaywall = true
                                        }
                                    }
                                }
                            )
                            
                            ToolCard(
                                title: "Magnetic",
                                icon: "gauge",
                                backgroundColor: Color(hex: "9B7EDE"),
                                action: {
                                    if appProvider.isPremiumUser {
                                        appProvider.navigationPath.append(NavigationDestination.compassVisualDetail)
                                    } else {
                                        if appProvider.hasExpiredTrial {
                                            appProvider.showPaywall = true
                                        } else {
                                            appProvider.showOnboardingPaywall = true
                                        }
                                    }
                                }
                            )
                        }
                        
                        HStack(spacing: 16) {
                            ToolCard(
                                title: "Camera",
                                icon: "camera.aperture",
                                backgroundColor: Color(hex: "F5A3C7"),
                                action: {
                                    if appProvider.isPremiumUser {
                                        appProvider.navigationPath.append(NavigationDestination.blinkingScanner)
                                    } else {
                                        if appProvider.hasExpiredTrial {
                                            appProvider.showPaywall = true
                                        } else {
                                            appProvider.showOnboardingPaywall = true
                                        }
                                    }
                                }
                            )
                            
                            Color.clear
                                .frame(height: 160)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.1)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.accentColor)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("History")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Recent scan results")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                appProvider.navigationPath.append(NavigationDestination.scanHistory)
                            }) {
                                HStack(spacing: 4) {
                                    Text("See all")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .foregroundColor(.accentColor)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                        
                        if scanHistoryManager.scanHistory.isEmpty {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: "clock.badge.questionmark")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.gray.opacity(0.6))
                                        .symbolRenderingMode(.hierarchical)
                                }
                                
                                VStack(spacing: 6) {
                                    Text("No recent scans")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text("Your scan history will appear here")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray.opacity(0.8))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(scanHistoryManager.scanHistory.prefix(3)) { item in
                                    RecentScanRow(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            scanHistoryManager.loadHistory()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToolCard: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(backgroundColor)
            .cornerRadius(20)
        }
    }
}

struct RecentScanRow: View {
    let item: ScanHistoryItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: iconForScanType(item.scanType))
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 40, height: 40)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.scanType.rawValue + " Scan")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(item.formattedDate)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("\(item.devicesFound)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.accentColor)
                
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    ForEach(0..<min(item.devices.count, 3), id: \.self) { index in
                        let device = item.devices[index]
                        HStack {
                            Image(systemName: deviceIcon(for: device))
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.name.isEmpty ? "Unknown Device" : device.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text(device.address)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if let signal = device.signalStrength {
                                HStack(spacing: 4) {
                                    Image(systemName: signalIcon(for: signal))
                                        .font(.system(size: 12))
                                    Text("\(signal) dBm")
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        if index < min(item.devices.count, 3) - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.2))
                                .padding(.leading, 40)
                        }
                    }
                    
                    if item.devices.count > 3 {
                        Button(action: {
                            AppProvider.shared.navigationPath.append(NavigationDestination.scanHistory)
                        }) {
                            Text("View all \(item.devices.count) devices")
                                .font(.system(size: 14))
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func iconForScanType(_ type: ScanHistoryItem.ScanType) -> String {
        switch type {
        case .wifi:
            return "wifi"
        case .bluetooth:
            return "dot.radiowaves.left.and.right"
        case .lan:
            return "network"
        }
    }
    
    private func deviceIcon(for device: ScanHistoryItem.DeviceInfo) -> String {
        if let type = device.type?.lowercased() {
            if type.contains("camera") {
                return "camera.fill"
            } else if type.contains("phone") || type.contains("mobile") {
                return "iphone"
            } else if type.contains("computer") || type.contains("laptop") {
                return "laptopcomputer"
            } else if type.contains("router") || type.contains("gateway") {
                return "wifi.router"
            } else if type.contains("tv") || type.contains("television") {
                return "tv"
            } else if type.contains("speaker") || type.contains("audio") {
                return "hifispeaker"
            } else if type.contains("printer") {
                return "printer"
            }
        }
        return "wifi"
    }
    
    private func signalIcon(for strength: Int) -> String {
        if strength >= -50 {
            return "wifi"
        } else if strength >= -70 {
            return "wifi.exclamationmark"
        } else {
            return "wifi.slash"
        }
    }
}
