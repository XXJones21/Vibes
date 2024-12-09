import RealityKit

/// Component for storing nexus particle data and complex behavior
@available(visionOS 2.0, *)
public struct NexusComponent: Component {
    // MARK: - Properties
    
    /// The current intensity of the effect (0-1)
    public var intensity: Float = 0
    
    /// The base birth rate for particles
    public var baseBirthRate: Float = 1000
    
    /// The base particle size
    public var baseSize: Float = 0.05
    
    /// The base particle lifetime
    public var baseLifetime: Float = 3.0
    
    /// The base acceleration applied to particles
    public var baseAcceleration: SIMD3<Float> = [0, 0.1, 0]
    
    /// The base velocity for particles
    public var baseVelocity: Float = 0.5
    
    /// Color configuration for the particles
    public var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// Physics parameters for complex behavior
    public var physicsParams: NexusPhysicsParams
    
    // MARK: - Initialization
    
    /// Initialize a new nexus component with default settings
    public init(
        colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6))),
        physicsParams: NexusPhysicsParams = .default
    ) {
        self.colorConfig = colorConfig
        self.physicsParams = physicsParams
        
        // Schedule system registration on main actor
        Task { @MainActor in
            NexusSystem.registerSystem()
        }
    }
}

/// Physics parameters for complex nexus behavior
public struct NexusPhysicsParams {
    /// Strength of attraction to center
    public var centerAttraction: Float = 0.5
    
    /// Strength of particle-to-particle interaction
    public var particleInteraction: Float = 0.1
    
    /// Maximum interaction distance
    public var interactionRadius: Float = 5.0
    
    /// Damping factor for particle motion
    public var damping: Float = 0.98
    
    /// Default physics parameters
    public static var `default`: NexusPhysicsParams {
        NexusPhysicsParams()
    }
    
    /// Initialize physics parameters with default values
    public init(
        centerAttraction: Float = 0.5,
        particleInteraction: Float = 0.1,
        interactionRadius: Float = 5.0,
        damping: Float = 0.98
    ) {
        self.centerAttraction = centerAttraction
        self.particleInteraction = particleInteraction
        self.interactionRadius = interactionRadius
        self.damping = damping
    }
} 