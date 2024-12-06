import RealityKit

/// A particle effect that creates a split galaxy formation with individual swirls.
/// Perfect for creating a cosmic, ethereal atmosphere.
public struct GalaxySplitEffect {
    /// Creates a preconfigured emitter component for a single split galaxy effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .sphere
        component.emitterShapeSize = [1.5, 1.5, 1.5]
        
        // Configure particle appearance
        let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.5, green: 0.0, blue: 0.5, alpha: 0.9
        )
        let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7
        )
        component.mainEmitter.color = .evolving(
            start: .single(purpleColor),
            end: .single(blueColor)
        )
        component.mainEmitter.birthRate = 100
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 3.0
        component.mainEmitter.acceleration = [0, 0.05, 0]
        component.speed = 0.2
        
        return component
    }
} 