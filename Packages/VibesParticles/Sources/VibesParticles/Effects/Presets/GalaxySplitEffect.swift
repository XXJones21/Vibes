import RealityKit

/// A specialized galaxy effect that splits into multiple emitters, used primarily for the VIBES letter animation.
/// Creates a cosmic effect that can be positioned to form text or patterns.
@available(visionOS 2.0, *)
public struct GalaxySplitEffect {
    /// Creates a preconfigured emitter component for a single split galaxy effect
    public static var emitterComponent: AetherEmitterComponent {
        let purpleColor = AetherEmitterComponent.ColorConfig.Color(
            red: 0.5, green: 0.0, blue: 0.5, alpha: 0.9
        )
        let blueColor = AetherEmitterComponent.ColorConfig.Color(
            red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7
        )
        return AetherEmitterComponent(
            shape: .sphere,
            emitterSize: [1.5, 1.5, 1.5],
            birthRate: 100,
            lifetime: 3.0,
            speed: 0.2,
            scale: [1, 1, 1],
            colorConfig: .evolving(start: purpleColor, end: blueColor),
            bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
            acceleration: [0, 0.05, 0]
        )
    }
    
    /// Predefined positions for the letters in "VIBES"
    public static let letterPositions: [SIMD3<Float>] = [
        [-2.0, 0, 0],  // V
        [-1.0, 0, 0],  // I
        [0.0, 0, 0],   // B
        [1.0, 0, 0],   // E
        [2.0, 0, 0]    // S
    ]
} 