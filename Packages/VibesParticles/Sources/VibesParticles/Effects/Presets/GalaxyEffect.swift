import RealityKit

/// A particle effect that creates a swirling galaxy formation.
/// Perfect for creating a cosmic, ethereal atmosphere.
@available(visionOS 2.0, *)
public struct GalaxyEffect {
    /// Creates a preconfigured emitter component for the galaxy effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .sphere
        component.emitterShapeSize = [6, 6, 6]
        
        // Configure particle appearance
        let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8
        )
        let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6
        )
        component.mainEmitter.color = .evolving(
            start: .single(purpleColor),
            end: .single(blueColor)
        )
        component.mainEmitter.birthRate = 150
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 4.0
        component.mainEmitter.acceleration = [0, 0.1, -0.5]
        component.speed = 0.3
        
        return component
    }
} 