import RealityKit

/// A particle effect that creates ethereal smoke that rises and fades.
/// Creates a mysterious, atmospheric effect with gentle upward movement.
@available(visionOS 2.0, *)
public struct SmokeEffect {
    /// Creates a preconfigured emitter component for the smoke effect
    public static var emitterComponent: AetherEmitterComponent {
        let startColor = AetherEmitterComponent.ColorConfig.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4
        )
        let endColor = AetherEmitterComponent.ColorConfig.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0
        )
        return AetherEmitterComponent(
            shape: .sphere,
            emitterSize: [1, 1, 1],
            birthRate: 50,
            lifetime: 1.0,
            speed: 0.1,
            scale: [1, 1, 1],
            colorConfig: .evolving(start: startColor, end: endColor),
            bounds: .init(min: [-5, -5, -5], max: [5, 5, 5]),
            acceleration: [0, 0.2, 0]
        )
    }
} 