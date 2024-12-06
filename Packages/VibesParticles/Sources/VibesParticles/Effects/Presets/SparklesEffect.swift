import RealityKit

/// A particle effect that creates bright, twinkling sparkles that fall gently.
/// Perfect for creating a magical, celebratory atmosphere.
@available(visionOS 2.0, *)
public struct SparklesEffect {
    /// Creates a preconfigured emitter component for the sparkles effect
    public static var emitterComponent: AetherEmitterComponent {
        AetherEmitterComponent(
            shape: .point,
            emitterSize: [0.1, 0.1, 0.1],
            birthRate: 200,
            lifetime: 2.0,
            speed: 0.5,
            scale: [1, 1, 1],
            colorConfig: .constant(.white),
            bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
            acceleration: [0, -0.5, 0]
        )
    }
} 