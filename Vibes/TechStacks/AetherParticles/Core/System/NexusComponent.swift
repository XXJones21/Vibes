import RealityKit

/// Component for storing nexus particle data and complex behavior
@available(visionOS 2.0, *)
struct NexusComponent: Component {
    /// The current intensity of the effect (0-1)
    var intensity: Float = 0
    
    /// The base birth rate for particles
    var baseBirthRate: Float = 1000
    
    /// The base particle size
    var baseSize: Float = 0.05
    
    /// The base particle lifetime
    var baseLifetime: Float = 3.0
    
    /// The base acceleration applied to particles
    var baseAcceleration: SIMD3<Float> = [0, 0.1, 0]
    
    /// The base velocity for particles
    var baseVelocity: Float = 0.5
    
    /// Color configuration for the particles
    var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// Physics parameters for complex behavior
    var physicsParams: NexusPhysicsParams
    
    /// Initialize a new nexus component with default settings
    init(
        colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6))),
        physicsParams: NexusPhysicsParams = .default
    ) {
        self.colorConfig = colorConfig
        self.physicsParams = physicsParams
    }
}

/// Physics parameters for complex nexus behavior
struct NexusPhysicsParams {
    /// Strength of attraction to center
    var centerAttraction: Float = 0.5
    
    /// Strength of particle-to-particle interaction
    var particleInteraction: Float = 0.1
    
    /// Maximum interaction distance
    var interactionRadius: Float = 5.0
    
    /// Damping factor for particle motion
    var damping: Float = 0.98
    
    /// Default physics parameters
    static var `default`: NexusPhysicsParams {
        NexusPhysicsParams()
    }
} 