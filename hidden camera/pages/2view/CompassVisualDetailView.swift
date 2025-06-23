import SwiftUI

struct CompassGauge: View {
    var index: Double
    
    struct Arc: Shape {
        var startAngle: Angle
        var endAngle: Angle
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                        radius: rect.width / 2,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false)
            return path
        }
    }
    
    var body: some View {
        let gaugeSpan = 240.0
        let clamped = max(0, min(500, index))
        let valueRatio = clamped / 500.0
        let angle = -gaugeSpan / 2 + valueRatio * gaugeSpan
        
        ZStack(alignment: .center) {
            Image("circle")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Image("indicator")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.bottom, 20)
                .rotationEffect(.degrees(angle))
        }
    }
}

struct CompassVisualDetailView: View {
    @StateObject private var magneticFieldScanner = MagneticFieldScanner()
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                 HStack(alignment: .lastTextBaseline) {
                     Text("\(Int(magneticFieldScanner.fieldStrength))")
                         .font(.system(size: 60, weight: .bold))
                         .foregroundColor(.customButton)
                     Text("µT")
                         .font(.title2)
                         .foregroundColor(.gray)
                 }
                 .padding(.horizontal, 20)
                 .padding(.vertical, 10)
                 .background(Color(hex: "1c2021"))
                 .cornerRadius(15)
                 .padding(.vertical, 30)
                
                CompassGauge(index: magneticFieldScanner.fieldStrength)
                    .padding(.bottom, 30)
                
                Spacer()
                
                Button(action: {
                    if magneticFieldScanner.isScanning {
                        magneticFieldScanner.stop()
                    } else {
                        magneticFieldScanner.startMagnetometer()
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: magneticFieldScanner.isScanning ? "stop.circle.fill" : "dial.high")
                            .font(.system(size: 24, weight: .semibold))
                        Text(magneticFieldScanner.isScanning ? "Stop" : "Start")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: magneticFieldScanner.isScanning 
                                ? [Color(hex: "FF6B6B"), Color(hex: "FF4757")] 
                                : [Color.accentColor, Color.accentColor.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: magneticFieldScanner.isScanning ? Color.red.opacity(0.3) : Color.accentColor.opacity(0.3), radius: 15, x: 0, y: 8)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 25)
                    .scaleEffect(magneticFieldScanner.isScanning ? 0.98 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: magneticFieldScanner.isScanning)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Visual Compass")
                    .foregroundStyle(.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if magneticFieldScanner.isScanning {
                magneticFieldScanner.stop()
            }
        }
    }
}
