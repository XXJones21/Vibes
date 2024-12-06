import RealityKit

/// A particle effect that creates a swirling galaxy of particles with evolving colors.
/// Creates an expansive, cosmic atmosphere with purple to blue color transitions.
@available(visionOS 2.0, *)
public struct GalaxyEffect {
    /// Creates a preconfigured emitter component for the galaxy effect
    public static var emitterComponent: AetherEmitterComponent {
        let purpleColor = AetherEmitterComponent.ColorConfig.Color(
            red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8
        )
        let blueColor = AetherEmitterComponent.ColorConfig.Color(
            red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6
        )
        return AetherEmitterComponent(
            shape: .sphere,
            emitterSize: [6, 6, 6],
            birthRate: 150,
            lifetime: 4.0,
            speed: 0.3,
            scale: [1, 1, 1],
            colorConfig: .evolving(start: purpleColor, end: blueColor),
            bounds: .init(min: [-8, -8, -8], max: [8, 8, 8]),
            acceleration: [0, 0.1, -0.5]
        )
    }
} 