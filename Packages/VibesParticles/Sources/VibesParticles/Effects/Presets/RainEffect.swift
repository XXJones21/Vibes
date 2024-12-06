import RealityKit

/// A particle effect that creates a gentle rain effect.
/// Perfect for creating a calming, atmospheric effect.
public struct RainEffect {
    /// Creates a preconfigured emitter component for the rain effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .plane
        component.emitterShapeSize = [10, 0.1, 10]
        
        // Configure particle appearance
        let rainColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3
        )
        component.mainEmitter.color = .constant(.single(rainColor))
        component.mainEmitter.birthRate = 300
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 1.0
        component.mainEmitter.acceleration = [0, -2.0, 0]
        component.speed = 1.0
        
        return component
    }
} 