import SwiftUI

struct ScanningProgressView: View {
    let progress: Double
    let isScanning: Bool
    let iconName: String
    
    var body: some View {
        VStack(spacing: StyleGuide.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(StyleGuide.Navigation.backgroundColor)
                    .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: StyleGuide.Scanning.progressLineWidth)
                    .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color.customButton, style: StrokeStyle(lineWidth: StyleGuide.Scanning.progressLineWidth, lineCap: .round))
                    .frame(width: StyleGuide.Scanning.progressCircleSize, height: StyleGuide.Scanning.progressCircleSize)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: progress)
                
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: StyleGuide.Scanning.iconSize, height: StyleGuide.Scanning.iconSize)
                    .foregroundColor(isScanning ? Color(hex: "29B684") : (progress >= 1.0 ? .customButton : .gray))
            }
            
            if isScanning {
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .foregroundColor(StyleGuide.Typography.titleColor)
            }
        }
    }
}

#Preview {
    ScanningProgressView(
        progress: 0.75,
        isScanning: true,
        iconName: "searchicon"
    )
    .padding()
    .background(Color.black)
}