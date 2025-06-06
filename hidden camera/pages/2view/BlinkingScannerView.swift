import AVFoundation
import CoreImage
import UIKit
import SwiftUI

struct FrameView: View {
    var image: CGImage?
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: Text("Camera frame"))
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else {
            Color.black.ignoresSafeArea()
        }
    }
}

final class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var activeFilter: BlinkingScannerView.FilterColor? = .red
    
    private let captureSession = AVCaptureSession()
    private let context = CIContext()
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else { return }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .medium
        captureSession.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}

extension CIImage {
    func oriented(_ orientation: CGImagePropertyOrientation) -> CIImage {
        self.oriented(forExifOrientation: Int32(orientation.rawValue))
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let orientation = CGImagePropertyOrientation.right
        var image = CIImage(cvPixelBuffer: buffer).oriented(orientation)
        
        image = image.applyingFilter("CIColorControls", parameters: [
            kCIInputContrastKey: 3.0,      // more contrast
            kCIInputBrightnessKey: -0.05,  // slight darken
            kCIInputSaturationKey: 0.0     // grayscale
        ])
        
        image = image.applyingFilter("CIGaussianBlur", parameters: [
            kCIInputRadiusKey: 0.8
        ])
        
        let filterColor = activeFilter
        let tintColor: CIColor = {
            switch filterColor {
            case .red:
                return CIColor(red: 1.0, green: 0.1, blue: 0.1)
            case .green:
                return CIColor(red: 0.1, green: 1.0, blue: 0.1)
            case .blue:
                return CIColor(red: 0.1, green: 0.1, blue: 1.0)
            case .none:
                return CIColor(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }()
        
        let redOverlay = CIImage(color: tintColor).cropped(to: image.extent)
        
        image = redOverlay.applyingFilter("CIMultiplyCompositing", parameters: [
            kCIInputBackgroundImageKey: image
        ])
        
        guard let cgImage = context.createCGImage(image, from: image.extent) else { return }
        
        DispatchQueue.main.async {
            self.frame = cgImage
        }
    }
}

struct BlinkingScannerView: View {
    @State private var selectedFilter: FilterColor? = .red
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var handler = FrameHandler()
    
    enum FilterColor: String, CaseIterable {
        case red, green, blue
        
        var color: Color {
            switch self {
            case .red: return .red
            case .green: return .green
            case .blue: return .blue
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                FrameView(image: handler.frame)
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width)
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        ForEach(FilterColor.allCases, id: \.self) { filter in
                            Button(action: {
                                withAnimation {
                                    selectedFilter = filter
                                    handler.activeFilter = selectedFilter
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(filter.color.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(filter.color, lineWidth: selectedFilter == filter ? 3 : 1)
                                        )
                                    
                                    Image(systemName: "camera.filters")
                                        .foregroundColor(filter.color)
                                        .font(.system(size: 20, weight: .bold))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.bottom)
                }
                .frame(width: geometry.size.width)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.accentColor.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Device Scanner")
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                    }
                }
            }
            .tint(.white)
        }
    }
}
