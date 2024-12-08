import RealityKit
import SwiftUI

/// AetherParticles is a specialized particle system for creating ethereal, music-reactive visualizations in visionOS.
/// 
/// This system provides a high-level interface for creating immersive particle effects that respond to music and create
/// atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.
///
/// Key features:
/// - Music-reactive particle behaviors
/// - Ethereal visual effects
/// - Preset configurations for different moods
/// - Support for complex animations like the welcome sequence
/// - Optimized for visionOS spatial experiences
@available(visionOS 2.0, *)
class AetherParticles: ObservableObject {
    // MARK: - Properties
    
    /// Standard bounds for all particle systems
    static let standardBounds = BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5])
    
    /// The root entity that hosts the particle emitter
    var rootEntity: Entity { _rootEntity }
    private let _rootEntity: Entity
    
    /// The current state of the particle system
    @Published private(set) var state: AetherState = .inactive
    
    // MARK: - Private Properties
    
    /// The main particle emitter component
    private var emitterComponent: ParticleEmitterComponent
    
    /// The current configuration of the particle system
    private(set) var configuration: AetherConfiguration
    
    // MARK: - Types
    
    /// Represents the current state of the particle system
    enum AetherState {
        /// System is not emitting particles
        case inactive
        /// System is actively emitting particles
        case active
        /// System is in the middle of a state change
        case transitioning
        /// System has finished its current sequence
        case complete
    }
    
    /// Available particle system presets
    enum AetherPreset {
        case fireflies
        case sparkles
        case smoke
        case rain
        case galaxy
        case galaxySplit
        
        var configuration: AetherConfiguration {
            switch self {
            case .fireflies:
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [2, 2, 2],
                    birthRate: 500,
                    colorConfig: .constant(.single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 1.0,
                        green: 1.0,
                        blue: 1.0,
                        alpha: 1.0
                    ))),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.1,
                    lifetime: 2.0
                )
                
            case .galaxy:
                let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.5,
                    green: 0.0,
                    blue: 0.5,
                    alpha: 0.8
                )
                let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.0,
                    green: 0.0,
                    blue: 1.0,
                    alpha: 0.6
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [6, 6, 6],
                    birthRate: 150,
                    colorConfig: .evolving(
                        start: .single(purpleColor),
                        end: .single(blueColor)
                    ),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.1, -0.5],
                    speed: 0.3,
                    lifetime: 4.0
                )
                
            case .galaxySplit:
                let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.5,
                    green: 0.0,
                    blue: 0.5,
                    alpha: 0.9
                )
                let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.0,
                    green: 0.0,
                    blue: 1.0,
                    alpha: 0.7
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1.5, 1.5, 1.5],
                    birthRate: 100,
                    colorConfig: .evolving(
                        start: .single(purpleColor),
                        end: .single(blueColor)
                    ),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.2,
                    lifetime: 3.0
                )
                
            case .sparkles:
                let whiteColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 1.0
                )
                return AetherConfiguration(
                    emitterShape: .point,
                    emitterSize: [0.1, 0.1, 0.1],
                    birthRate: 200,
                    colorConfig: .constant(.single(whiteColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, -0.5, 0],
                    speed: 0.5,
                    lifetime: 2.0
                )
                
            case .smoke:
                let startWhite = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.4
                )
                let endWhite = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.0
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1, 1, 1],
                    birthRate: 50,
                    colorConfig: .evolving(
                        start: .single(startWhite),
                        end: .single(endWhite)
                    ),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.2, 0],
                    speed: 0.1,
                    lifetime: 1.0
                )
                
            case .rain:
                let rainColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.3
                )
                return AetherConfiguration(
                    emitterShape: .plane,
                    emitterSize: [10, 0.1, 10],
                    birthRate: 300,
                    colorConfig: .constant(.single(rainColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, -2.0, 0],
                    speed: 1.0,
                    lifetime: 1.0
                )
            }
        }
    }
    
    /// Configuration for the particle system
    struct AetherConfiguration {
        /// The shape of the particle emitter (e.g., sphere, plane)
        var emitterShape: ParticleEmitterComponent.EmitterShape
        
        /// The size of the emitter shape in meters
        var emitterSize: SIMD3<Float>
        
        /// The rate at which new particles are created (particles per second)
        var birthRate: Float
        
        /// The color configuration for particles (constant, evolving, or random)
        var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
        
        /// The 3D bounds in which particles can exist
        var bounds: BoundingBox
        
        /// The acceleration applied to particles (in meters per second squared)
        var acceleration: SIMD3<Float>
        
        /// The initial speed of particle movement (in meters per second)
        var speed: Float
        
        /// The lifetime of each particle in seconds
        var lifetime: Float
        
        /// Creates a default configuration with moderate values
        static var `default`: AetherConfiguration {
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
        
        init(
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
    
    // MARK: - Initialization
    
    /// Creates a new AetherParticles system with the specified configuration
    init(configuration: AetherConfiguration = .default) {
        self.configuration = configuration
        self._rootEntity = Entity()
        self.emitterComponent = ParticleEmitterComponent()
        
        setupEmitter()
    }
    
    // MARK: - Methods
    
    /// Creates a particle system with a specific preset configuration
    static func withPreset(_ preset: AetherPreset) -> AetherParticles {
        AetherParticles(configuration: preset.configuration)
    }
    
    /// Starts the particle system
    func start() {
        guard state == .inactive else { return }
        state = .active
        emitterComponent.mainEmitter.birthRate = configuration.birthRate
        updateEmitter()
    }
    
    /// Stops the particle system and clears all particles
    func stop() {
        state = .inactive
        emitterComponent.mainEmitter.birthRate = 0
        updateEmitter()
    }
    
    /// Updates the configuration of the particle system
    func update(with configuration: AetherConfiguration) {
        self.configuration = configuration
        setupEmitter()
    }
    
    // MARK: - Private Methods
    
    private func setupEmitter() {
        // Configure emitter shape and size
        emitterComponent.emitterShape = configuration.emitterShape
        emitterComponent.emitterShapeSize = configuration.emitterSize
        
        // Configure particle appearance
        emitterComponent.mainEmitter.color = configuration.colorConfig
        emitterComponent.mainEmitter.birthRate = 0  // Start inactive
        emitterComponent.mainEmitter.size = 0.05  // Set particle size to about quarter size (5cm diameter)
        emitterComponent.mainEmitter.lifeSpan = Double(configuration.lifetime)  // Set lifetime
        
        // Configure movement
        emitterComponent.mainEmitter.acceleration = configuration.acceleration
        emitterComponent.speed = configuration.speed
        
        // Add to root entity
        _rootEntity.components.set(emitterComponent)
        
        // Position within bounds
        _rootEntity.position = [0, 0, 0]
    }
    
    private func updateEmitter() {
        _rootEntity.components.set(emitterComponent)
    }
    
    // Helper for rainbow colors
    static func randomRainbowColor() -> ParticleEmitterComponent.ParticleEmitter.ParticleColor {
        let hues: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        let randomHue = hues.randomElement() ?? 0
        let nextHue = hues.first(where: { $0 > randomHue }) ?? hues[0]
        
        // Convert hue to RGB for start color
        let (r1, g1, b1) = hueToRGB(hue: randomHue)
        let startColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: CGFloat(r1),
            green: CGFloat(g1),
            blue: CGFloat(b1),
            alpha: 0.8
        )
        
        // Convert hue to RGB for end color
        let (r2, g2, b2) = hueToRGB(hue: nextHue)
        let endColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: CGFloat(r2),
            green: CGFloat(g2),
            blue: CGFloat(b2),
            alpha: 0.6
        )
        
        return .evolving(
            start: .single(startColor),
            end: .single(endColor)
        )
    }

    // Convert hue to RGB (helper function)
    private static func hueToRGB(hue: CGFloat) -> (Float, Float, Float) {
        let h = hue * 6.0
        let i = floor(h)
        let f = h - i
        let p = 0.0
        let q = 1.0 - f
        let t = f
        
        switch Int(i) % 6 {
        case 0: return (1.0, Float(t), 0.0)
        case 1: return (Float(q), 1.0, 0.0)
        case 2: return (0.0, 1.0, Float(t))
        case 3: return (0.0, Float(q), 1.0)
        case 4: return (Float(t), 0.0, 1.0)
        case 5: return (1.0, 0.0, Float(q))
        default: return (0.0, 0.0, 0.0)
        }
    }
}

// MARK: - Letter Animation Support

@available(visionOS 2.0, *)
extension AetherParticles {
    /// Predefined positions for the letters in "VIBES"
    static let letterPositions: [SIMD3<Float>] = [
        [-2.0, 0, 0],  // V
        [-1.0, 0, 0],  // I
        [0.0, 0, 0],   // B
        [1.0, 0, 0],   // E
        [2.0, 0, 0]    // S
    ]
    
    /// Creates a particle system configured for a specific letter position
    static func forLetterPosition(_ index: Int) -> AetherParticles {
        precondition(index >= 0 && index < letterPositions.count, "Letter index out of bounds")
        
        let system = AetherParticles(configuration: AetherPreset.galaxySplit.configuration)
        system._rootEntity.position = letterPositions[index]
        return system
    }
} 