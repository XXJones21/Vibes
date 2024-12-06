import RealityKit

/// A particle effect that creates a gentle rain effect falling from above.
/// Creates an immersive precipitation effect with translucent droplets.
@available(visionOS 2.0, *)
public struct RainEffect {
    /// Creates a preconfigured emitter component for the rain effect
    public static var emitterComponent: AetherEmitterComponent {
        let rainColor = AetherEmitterComponent.ColorConfig.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3
        )
        return AetherEmitterComponent(
            shape: .plane,
            emitterSize: [10, 0.1, 10],
            birthRate: 300,
            lifetime: 1.0,
            speed: 1.0,
            scale: [1, 1, 1],
            colorConfig: .constant(rainColor),
            bounds: .init(min: [-10, -10, -10], max: [10, 10, 10]),
            acceleration: [0, -2.0, 0]
        )
    }
} 