import SwiftUI

struct ScanHistoryView: View {
    @StateObject private var historyManager = ScanHistoryManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if historyManager.scanHistory.isEmpty {
                VStack(spacing: 25) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 50))
                            .foregroundColor(.accentColor)
                    }
                    .shadow(color: .accentColor.opacity(0.2), radius: 20, x: 0, y: 10)
                    
                    VStack(spacing: 12) {
                        Text("No Scan History")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Your scan history will appear here")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("Complete a scan to see it saved here")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.accentColor.opacity(0.7))
                        
                        Text("Scan history is stored locally on your device")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(historyManager.scanHistory) { item in
                            ScanHistoryRow(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Scan History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.customBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(Color.customButton)
                }
            }
            
            if !historyManager.scanHistory.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Clear History", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                historyManager.clearHistory()
            }
        } message: {
            Text("Are you sure you want to clear all scan history? This action cannot be undone.")
        }
    }
}

struct ScanHistoryRow: View {
    let item: ScanHistoryItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: iconForScanType(item.scanType))
                                .foregroundColor(.accentColor)
                                .font(.system(size: 20))
                            
                            Text(item.scanType.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(item.formattedDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Text(item.summary)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .padding(.trailing)
                }
                .background(Color.gray.opacity(0.15))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(item.devices.enumerated()), id: \.offset) { index, device in
                        DeviceHistoryRow(device: device)
                    }
                }
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
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
}

struct DeviceHistoryRow: View {
    let device: ScanHistoryItem.DeviceInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Text(device.address)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let manufacturer = device.manufacturer {
                        Text(manufacturer)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                    }
                    
                    if let signal = device.signalStrength {
                        HStack(spacing: 2) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 10))
                            Text("\(signal) dBm")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.08))
        .cornerRadius(8)
    }
}