import RealityKit

/// A particle effect that creates floating, glowing particles reminiscent of fireflies.
/// Perfect for creating a magical, ethereal atmosphere.
@available(visionOS 2.0, *)
public struct FirefliesEffect {
    /// Creates a preconfigured emitter component for the fireflies effect
    public static var emitterComponent: AetherEmitterComponent {
        AetherEmitterComponent(
            shape: .sphere,
            emitterSize: [2, 2, 2],
            birthRate: 500,
            lifetime: 2.0,
            speed: 0.1,
            scale: [1, 1, 1],
            colorConfig: .constant(.white),
            bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
            acceleration: [0, 0.05, 0]
        )
    }
} 