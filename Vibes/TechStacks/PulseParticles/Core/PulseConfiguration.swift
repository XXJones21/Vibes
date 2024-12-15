import RealityKit
import Foundation

/// Configuration for pulse particle effects
@available(visionOS 2.0, *)
public struct PulseConfiguration: Codable {
    // MARK: - Properties
    
    /// Rate at which particles are emitted
    public var birthRate: Float
    
    /// Size of emitted particles
    public var size: Float
    
    /// How long particles exist before being removed
    public var lifetime: Float
    
    /// Movement speed of particles
    public var speed: Float
    
    /// Shape of the particle emitter
    public var emitterShape: EmitterShape
    
    /// Size of the emitter shape
    public var emitterSize: SIMD3<Float>
    
    /// Base acceleration applied to particles
    public var acceleration: SIMD3<Float>
    
    /// Color configuration for particles
    public var color: PulseColor
    
    // MARK: - Types
    
    /// Shape of the particle emitter
    public enum EmitterShape: String, Codable {
        case point
        case sphere
        case box
        
        /// Convert to RealityKit emitter shape
        var realityKitShape: ParticleEmitterComponent.EmitterShape {
            switch self {
            case .point: return .point
            case .sphere: return .sphere
            case .box: return .box
            }
        }
    }
    
    /// Color configuration for particles
    public enum PulseColor: Codable {
        /// Single color for all particles
        case single(red: Float, green: Float, blue: Float, alpha: Float)
        /// Color that evolves over particle lifetime
        case evolving(start: SIMD4<Float>, end: SIMD4<Float>)
        
        /// Convert to RealityKit particle color
        var realityKitColor: ParticleEmitterComponent.ParticleEmitter.ParticleColor {
            switch self {
            case .single(let r, let g, let b, let a):
                let color = ParticleEmitterComponent.ParticleEmitter.Color(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
                return .constant(.single(color))
                
            case .evolving(let start, let end):
                let startColor = ParticleEmitterComponent.ParticleEmitter.Color(red: CGFloat(start.x), green: CGFloat(start.y), blue: CGFloat(start.z), alpha: CGFloat(start.w))
                let endColor = ParticleEmitterComponent.ParticleEmitter.Color(red: CGFloat(end.x), green: CGFloat(end.y), blue: CGFloat(end.z), alpha: CGFloat(end.w))
                return .evolving(start: .single(startColor), end: .single(endColor))
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Create a new pulse configuration
    public init(
        birthRate: Float,
        size: Float,
        lifetime: Float,
        speed: Float,
        emitterShape: EmitterShape,
        emitterSize: SIMD3<Float>,
        acceleration: SIMD3<Float>,
        color: PulseColor
    ) {
        self.birthRate = birthRate
        self.size = size
        self.lifetime = lifetime
        self.speed = speed
        self.emitterShape = emitterShape
        self.emitterSize = emitterSize
        self.acceleration = acceleration
        self.color = color
    }
    
    /// Default configuration
    public static var `default`: PulseConfiguration {
        PulseConfiguration(
            birthRate: 100,
            size: 0.05,
            lifetime: 2.0,
            speed: 0.5,
            emitterShape: .sphere,
            emitterSize: [1, 1, 1],
            acceleration: [0, 0.1, 0],
            color: .single(red: 1, green: 1, blue: 1, alpha: 0.6)
        )
    }
} 