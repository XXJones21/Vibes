import RealityKit

/// Configuration for the particle system
@available(visionOS 2.0, *)
public struct AetherConfiguration {
    /// The shape of the particle emitter (e.g., sphere, plane)
    public var emitterShape: ParticleEmitterComponent.EmitterShape
    
    /// The size of the emitter shape in meters
    public var emitterSize: SIMD3<Float>
    
    /// The rate at which new particles are created (particles per second)
    public var birthRate: Float
    
    /// The color configuration for particles (constant, evolving, or random)
    public var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// The 3D bounds in which particles can exist
    public var bounds: BoundingBox
    
    /// The acceleration applied to particles (in meters per second squared)
    public var acceleration: SIMD3<Float>
    
    /// The initial speed of particle movement (in meters per second)
    public var speed: Float
    
    /// The lifetime of each particle in seconds
    public var lifetime: Float
    
    /// Creates a default configuration with moderate values
    public static var `default`: AetherConfiguration {
        AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: [1, 1, 1],
            birthRate: 100,
            colorConfig: .constant(.single(.white.withAlphaComponent(0.6))),
            bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
            acceleration: [0, 0, 0],
            speed: 0.2,
            lifetime: 3.0
        )
    }
    
    public init(
        emitterShape: ParticleEmitterComponent.EmitterShape = .sphere,
        emitterSize: SIMD3<Float> = [1, 1, 1],
        birthRate: Float = 100,
        colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6))),
        bounds: BoundingBox = BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
        acceleration: SIMD3<Float> = [0, 0, 0],
        speed: Float = 0.2,
        lifetime: Float = 3.0
    ) {
        self.emitterShape = emitterShape
        self.emitterSize = emitterSize
        self.birthRate = birthRate
        self.colorConfig = colorConfig
        self.bounds = bounds
        self.acceleration = acceleration
        self.speed = speed
        self.lifetime = lifetime
    }
} 