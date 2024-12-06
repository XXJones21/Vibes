import RealityKit

/// A particle effect that creates ethereal smoke-like formations.
/// Perfect for creating a mystical, atmospheric effect.
public struct SmokeEffect {
    /// Creates a preconfigured emitter component for the smoke effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .sphere
        component.emitterShapeSize = [1, 1, 1]
        
        // Configure particle appearance
        let startColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4
        )
        let endColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0
        )
        component.mainEmitter.color = .evolving(
            start: .single(startColor),
            end: .single(endColor)
        )
        component.mainEmitter.birthRate = 50
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 1.0
        component.mainEmitter.acceleration = [0, 0.2, 0]
        component.speed = 0.1
        
        return component
    }
} 