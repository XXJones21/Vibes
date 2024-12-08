import RealityKit

/// Configuration for album pulse effects
@available(visionOS 2.0, *)
struct PulseConfiguration {
    /// The shape of the emitter
    var shape: ParticleEmitterComponent.EmitterShape
    
    /// The size of the emitter
    var size: SIMD3<Float>
    
    /// The particle birth rate
    var birthRate: Float
    
    /// The particle color configuration
    var color: ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// The size of individual particles
    var particleSize: Float
    
    /// The lifetime of particles
    var lifetime: Float
    
    /// The acceleration applied to particles
    var acceleration: SIMD3<Float>
    
    /// The initial speed of particles
    var speed: Float
    
    /// Default configuration for album pulses
    static var `default`: PulseConfiguration {
        PulseConfiguration(
            shape: .sphere,
            size: [0.1, 0.1, 0.1],  // Small, album-sized emitter
            birthRate: 100,
            color: .constant(.single(.white.withAlphaComponent(0.6))),
            particleSize: 0.02,  // Smaller particles for album effects
            lifetime: 1.0,
            acceleration: [0, 0.05, 0],
            speed: 0.1
        )
    }
} 