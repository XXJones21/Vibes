import RealityKit

/// A particle effect that creates bright, twinkling sparkles.
/// Perfect for creating a magical, energetic effect.
@available(visionOS 2.0, *)
public struct SparklesEffect {
    /// Creates a preconfigured emitter component for the sparkles effect
    public static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        component.emitterShape = .point
        component.emitterShapeSize = [0.1, 0.1, 0.1]
        
        // Configure particle appearance
        let whiteColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0
        )
        component.mainEmitter.color = .constant(.single(whiteColor))
        component.mainEmitter.birthRate = 200
        component.mainEmitter.size = 0.05
        component.mainEmitter.lifeSpan = 2.0
        component.mainEmitter.acceleration = [0, -0.5, 0]
        component.speed = 0.5
        
        return component
    }
} 