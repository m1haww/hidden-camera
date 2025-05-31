import CoreMotion
import SwiftUI

final class MagneticFieldScanner: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var fieldStrength: Double = 0.0
    
    @Published var isScanning: Bool = false

    func startMagnetometer() {
        guard motionManager.isMagnetometerAvailable else {
            print("Magnetometer not available")
            return
        }

        isScanning = true
        motionManager.magnetometerUpdateInterval = 0.1
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
            guard let field = data?.magneticField else { return }

            let strength = sqrt(
                field.x * field.x +
                field.y * field.y +
                field.z * field.z
            )

            self?.fieldStrength = strength
        }
    }

    func stop() {
        motionManager.stopMagnetometerUpdates()
        isScanning = false
    }
}
