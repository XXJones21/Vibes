import RealityKit
import SwiftUI

@available(visionOS 2.0, *)
public class AetherParticles: ObservableObject {
    // Root entity that will host the particle system
    public private(set) var rootEntity = Entity()
    
    // Particle emitter component
    private var emitterComponent: AetherEmitterComponent
    
    // Current configuration
    private var configuration: ParticleConfiguration
    
    // Whether the system is currently emitting
    @Published public private(set) var state: ParticleState = .inactive
    
    // Whether particles are being emitted
    private var isEmitting: Bool = false {
        didSet {
            emitterComponent.isEmitting = isEmitting
        }
    }
    
    // MARK: - Types
    
    public enum ParticleState {
        case inactive
        case active
        case transitioning
        case complete
    }
    
    // MARK: - Initialization
    
    public init(configuration: ParticleConfiguration = ParticlePreset.fireflies.configuration) {
        self.configuration = configuration
        self.emitterComponent = AetherEmitterComponent(
            shape: configuration.emitterShape,
            emitterSize: configuration.emitterSize,
            birthRate: configuration.birthRate,
            lifetime: configuration.lifetime,
            speed: configuration.speed,
            scale: configuration.scale,
            colorConfig: configuration.colorConfig,
            bounds: configuration.bounds,
            acceleration: configuration.acceleration
        )
        rootEntity.components[AetherEmitterComponent.self] = emitterComponent
    }
    
    // MARK: - Presets
    
    public enum ParticlePreset {
        case fireflies
        case galaxy
        case galaxySplit
        case sparkles
        case smoke
        case rain
        
        public var configuration: ParticleConfiguration {
            switch self {
            case .fireflies:
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [2, 2, 2],
                    birthRate: 500,
                    colorConfig: .constant(.white),
                    bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.1,
                    lifetime: 2.0
                )
                
            case .galaxy:
                let purpleColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8
                )
                let blueColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6
                )
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [6, 6, 6],
                    birthRate: 150,
                    colorConfig: .evolving(start: purpleColor, end: blueColor),
                    bounds: .init(min: [-8, -8, -8], max: [8, 8, 8]),
                    acceleration: [0, 0.1, -0.5],
                    speed: 0.3,
                    lifetime: 4.0
                )
                
            case .galaxySplit:
                let purpleColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 0.5, green: 0.0, blue: 0.5, alpha: 0.9
                )
                let blueColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7
                )
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1.5, 1.5, 1.5],
                    birthRate: 100,
                    colorConfig: .evolving(start: purpleColor, end: blueColor),
                    bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.2,
                    lifetime: 3.0
                )
                
            case .sparkles:
                let whiteColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0
                )
                return ParticleConfiguration(
                    emitterShape: .point,
                    emitterSize: [0.1, 0.1, 0.1],
                    birthRate: 200,
                    colorConfig: .constant(whiteColor),
                    bounds: .init(min: [-3, -3, -3], max: [3, 3, 3]),
                    acceleration: [0, -0.5, 0],
                    speed: 0.5,
                    lifetime: 2.0
                )
                
            case .smoke:
                let startWhite = AetherEmitterComponent.ColorConfig.Color(
                    red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4
                )
                let endWhite = AetherEmitterComponent.ColorConfig.Color(
                    red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0
                )
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1, 1, 1],
                    birthRate: 50,
                    colorConfig: .evolving(start: startWhite, end: endWhite),
                    bounds: .init(min: [-5, -5, -5], max: [5, 5, 5]),
                    acceleration: [0, 0.2, 0],
                    speed: 0.1,
                    lifetime: 1.0
                )
                
            case .rain:
                let rainColor = AetherEmitterComponent.ColorConfig.Color(
                    red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3
                )
                return ParticleConfiguration(
                    emitterShape: .plane,
                    emitterSize: [10, 0.1, 10],
                    birthRate: 300,
                    colorConfig: .constant(rainColor),
                    bounds: .init(min: [-10, -10, -10], max: [10, 10, 10]),
                    acceleration: [0, -2.0, 0],
                    speed: 1.0,
                    lifetime: 1.0
                )
            }
        }
    }
    
    // MARK: - Configuration
    
    public struct ParticleConfiguration {
        public var emitterShape: EmitterShape
        public var emitterSize: SIMD3<Float>
        public var birthRate: Float
        public var lifetime: Float
        public var speed: Float
        public var scale: SIMD3<Float>
        public var colorConfig: ColorConfig
        public var bounds: BoundingBox
        public var acceleration: SIMD3<Float>
        
        public init(
            emitterShape: EmitterShape = .sphere,
            emitterSize: SIMD3<Float> = [1, 1, 1],
            birthRate: Float = 100,
            colorConfig: ColorConfig = .constant(.white),
            bounds: BoundingBox = .init(min: [-5, -5, -5], max: [5, 5, 5]),
            acceleration: SIMD3<Float> = [0, 0, 0],
            speed: Float = 0.2,
            lifetime: Float = 2.0,
            scale: SIMD3<Float> = [1, 1, 1]
        ) {
            self.emitterShape = emitterShape
            self.emitterSize = emitterSize
            self.birthRate = birthRate
            self.lifetime = lifetime
            self.speed = speed
            self.scale = scale
            self.colorConfig = colorConfig
            self.bounds = bounds
            self.acceleration = acceleration
        }
        
        public static var `default`: ParticleConfiguration {
            ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [1, 1, 1],
                birthRate: 100,
                colorConfig: .constant(.white),
                bounds: .init(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, 0, 0],
                speed: 0.2,
                lifetime: 2.0,
                scale: [1, 1, 1]
            )
        }
    }
    
    // MARK: - Control
    
    public func start() {
        state = .transitioning
        isEmitting = true
        update(with: configuration)
        state = .active
    }
    
    public func stop() {
        state = .transitioning
        isEmitting = false
        emitterComponent.birthRate = 0
        state = .inactive
    }
    
    public func complete() {
        state = .transitioning
        isEmitting = false
        emitterComponent.birthRate = 0
        state = .complete
    }
    
    public func update(with configuration: ParticleConfiguration) {
        self.configuration = configuration
        if isEmitting {
            emitterComponent.shape = configuration.emitterShape
            emitterComponent.emitterSize = configuration.emitterSize
            emitterComponent.birthRate = configuration.birthRate
            emitterComponent.lifetime = configuration.lifetime
            emitterComponent.speed = configuration.speed
            emitterComponent.scale = configuration.scale
            emitterComponent.colorConfig = configuration.colorConfig
            emitterComponent.bounds = configuration.bounds
            emitterComponent.acceleration = configuration.acceleration
        }
    }
    
    // MARK: - Utilities
    
    public static func randomRainbowColor() -> ColorConfig {
        let hue = Float.random(in: 0...1)
        let saturation: Float = 0.8
        let brightness: Float = 0.8
        
        let startColor = AetherEmitterComponent.ColorConfig.Color(
            red: Float(1.0 - saturation),
            green: Float(brightness * saturation),
            blue: Float(brightness),
            alpha: 0.8
        )
        
        let endColor = AetherEmitterComponent.ColorConfig.Color(
            red: Float(brightness),
            green: Float(1.0 - saturation),
            blue: Float(brightness * saturation),
            alpha: 0.6
        )
        
        return .evolving(start: startColor, end: endColor)
    }
    
    // MARK: - Letter Positioning
    
    public static let letterPositions: [SIMD3<Float>] = [
        [-2.0, 0, 0],  // V
        [-1.0, 0, 0],  // I
        [0.0, 0, 0],   // B
        [1.0, 0, 0],   // E
        [2.0, 0, 0]    // S
    ]
    
    public static func forLetterPosition(_ index: Int) -> AetherParticles {
        let system = AetherParticles(configuration: ParticlePreset.galaxySplit.configuration)
        system.rootEntity.position = letterPositions[index]
        system.stop()
        return system
    }
    
    /// Creates a new AetherParticles instance with a preset configuration
    public static func withPreset(_ preset: ParticlePreset) -> AetherParticles {
        AetherParticles(configuration: preset.configuration)
    }
}

// Type aliases for convenience
@available(visionOS 2.0, *)
public extension AetherParticles {
    typealias EmitterShape = AetherEmitterComponent.EmitterShape
    typealias ColorConfig = AetherEmitterComponent.ColorConfig
} 