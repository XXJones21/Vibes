import RealityKit

/// A particle effect that creates floating, glowing particles reminiscent of fireflies.
/// Perfect for creating a magical, ethereal atmosphere.
public struct FirefliesEffect {
    /// Creates a preconfigured emitter component for the fireflies effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .sphere
        component.emitterShapeSize = [2, 2, 2]
        
        // Configure particle appearance
        component.mainEmitter.color = .constant(.single(.white))
        component.mainEmitter.birthRate = 500
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 2.0
        component.mainEmitter.acceleration = [0, 0.05, 0]
        component.speed = 0.1
        
        return component
    }
} 