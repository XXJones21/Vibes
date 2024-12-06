import RealityKit
import Foundation

/// Component that marks an entity as an aether particle emitter
@available(visionOS 2.0, *)
public struct AetherEmitterComponent: Component {
    /// The shape of the emitter
    public enum EmitterShape {
        case point
        case sphere
        case plane
    }
    
    /// Color configuration for particles
    public enum ColorConfig {
        /// A single, constant color
        case constant(Color)
        /// Color that changes over particle lifetime
        case evolving(start: Color, end: Color)
        /// Random colors from a predefined palette
        case rainbow
        
        public struct Color {
            public var red: Float
            public var green: Float
            public var blue: Float
            public var alpha: Float
            
            public init(red: Float, green: Float, blue: Float, alpha: Float) {
                self.red = red
                self.green = green
                self.blue = blue
                self.alpha = alpha
            }
            
            public static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)
            public static let clear = Color(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
    
    // Emitter properties
    public var isEmitting: Bool
    public var shape: EmitterShape
    public var emitterSize: SIMD3<Float>
    public var birthRate: Float
    public var lifetime: Float
    public var speed: Float
    public var scale: SIMD3<Float>
    public var colorConfig: ColorConfig
    public var bounds: BoundingBox
    public var acceleration: SIMD3<Float>
    
    public init(
        isEmitting: Bool = false,
        shape: EmitterShape = .sphere,
        emitterSize: SIMD3<Float> = [1, 1, 1],
        birthRate: Float = 100,
        lifetime: Float = 2.0,
        speed: Float = 0.5,
        scale: SIMD3<Float> = [1, 1, 1],
        colorConfig: ColorConfig = .constant(.white),
        bounds: BoundingBox = .init(min: [-5, -5, -5], max: [5, 5, 5]),
        acceleration: SIMD3<Float> = [0, 0, 0]
    ) {
        self.isEmitting = isEmitting
        self.shape = shape
        self.emitterSize = emitterSize
        self.birthRate = birthRate
        self.lifetime = lifetime
        self.speed = speed
        self.scale = scale
        self.colorConfig = colorConfig
        self.bounds = bounds
        self.acceleration = acceleration
    }
}

/// Component that marks an entity as an aether particle
@available(visionOS 2.0, *)
public struct AetherParticleComponent: Component {
    public var birthTime: TimeInterval
    public var lifetime: Float
    public var velocity: SIMD3<Float>
    public var startColor: AetherEmitterComponent.ColorConfig.Color
    public var endColor: AetherEmitterComponent.ColorConfig.Color
    
    public init(
        birthTime: TimeInterval,
        lifetime: Float,
        velocity: SIMD3<Float>,
        startColor: AetherEmitterComponent.ColorConfig.Color,
        endColor: AetherEmitterComponent.ColorConfig.Color
    ) {
        self.birthTime = birthTime
        self.lifetime = lifetime
        self.velocity = velocity
        self.startColor = startColor
        self.endColor = endColor
    }
} 