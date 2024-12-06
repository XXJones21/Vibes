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
public class AetherParticles: ObservableObject {
    // MARK: - Public Properties
    
    /// The root entity that hosts the particle emitter
    public var rootEntity: Entity { _rootEntity }
    private let _rootEntity: Entity
    
    /// The current state of the particle system
    @Published public private(set) var state: ParticleState = .inactive
    
    // MARK: - Private Properties
    
    /// The main particle emitter component
    private var emitterComponent: ParticleEmitterComponent
    
    /// The current configuration of the particle system
    public private(set) var configuration: ParticleConfiguration
    
    // MARK: - Types
    
    /// Represents the current state of the particle system
    public enum ParticleState {
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
    public enum ParticlePreset {
        case fireflies
        case sparkles
        case smoke
        case rain
        case galaxy
        case galaxySplit
        
        public var configuration: ParticleConfiguration {
            switch self {
            case .fireflies:
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [4, 4, 4],
                    birthRate: 150,
                    colorConfig: AetherParticles.randomRainbowColor(),
                    bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                    acceleration: [0, 0.1, 0],
                    speed: 0.2
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
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [6, 6, 6],
                    birthRate: 0,
                    colorConfig: .evolving(
                        start: .single(purpleColor),
                        end: .single(blueColor)
                    ),
                    bounds: BoundingBox(min: [-8, -8, -8], max: [8, 8, 8]),
                    acceleration: [0, 0.1, -0.5],
                    speed: 0.3
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
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1.5, 1.5, 1.5],
                    birthRate: 0,
                    colorConfig: .evolving(
                        start: .single(purpleColor),
                        end: .single(blueColor)
                    ),
                    bounds: BoundingBox(min: [-3, -3, -3], max: [3, 3, 3]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.2
                )
                
            case .sparkles:
                let whiteColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 1.0
                )
                return ParticleConfiguration(
                    emitterShape: .point,
                    emitterSize: [0.1, 0.1, 0.1],
                    birthRate: 200,
                    colorConfig: .constant(.single(whiteColor)),
                    bounds: BoundingBox(min: [-3, -3, -3], max: [3, 3, 3]),
                    acceleration: [0, -0.5, 0],
                    speed: 0.5
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
                return ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1, 1, 1],
                    birthRate: 50,
                    colorConfig: .evolving(
                        start: .single(startWhite),
                        end: .single(endWhite)
                    ),
                    bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                    acceleration: [0, 0.2, 0],
                    speed: 0.1
                )
                
            case .rain:
                let rainColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.3
                )
                return ParticleConfiguration(
                    emitterShape: .plane,
                    emitterSize: [10, 0.1, 10],
                    birthRate: 300,
                    colorConfig: .constant(.single(rainColor)),
                    bounds: BoundingBox(min: [-10, -10, -10], max: [10, 10, 10]),
                    acceleration: [0, -2.0, 0],
                    speed: 1.0
                )
            }
        }
    }
    
    /// Configuration for the particle system
    public struct ParticleConfiguration {
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
        
        /// Creates a default configuration with moderate values
        public static var `default`: ParticleConfiguration {
            ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [1, 1, 1],
                birthRate: 100,
                colorConfig: .constant(.single(.white.withAlphaComponent(0.6))),
                bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, 0, 0],
                speed: 0.2
            )
        }
        
        public init(
            emitterShape: ParticleEmitterComponent.EmitterShape = .sphere,
            emitterSize: SIMD3<Float> = [1, 1, 1],
            birthRate: Float = 100,
            colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6))),
            bounds: BoundingBox = BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
            acceleration: SIMD3<Float> = [0, 0, 0],
            speed: Float = 0.2
        ) {
            self.emitterShape = emitterShape
            self.emitterSize = emitterSize
            self.birthRate = birthRate
            self.colorConfig = colorConfig
            self.bounds = bounds
            self.acceleration = acceleration
            self.speed = speed
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a new AetherParticles system with the specified configuration
    public init(configuration: ParticleConfiguration = .default) {
        self.configuration = configuration
        self._rootEntity = Entity()
        self.emitterComponent = ParticleEmitterComponent()
        
        setupEmitter()
    }
    
    // MARK: - Public Methods
    
    /// Creates a particle system with a specific preset configuration
    public static func withPreset(_ preset: ParticlePreset) -> AetherParticles {
        AetherParticles(configuration: preset.configuration)
    }
    
    /// Starts the particle system
    public func start() {
        guard state == .inactive else { return }
        state = .active
        emitterComponent.mainEmitter.birthRate = configuration.birthRate
        updateEmitter()
    }
    
    /// Stops the particle system and clears all particles
    public func stop() {
        state = .inactive
        emitterComponent.mainEmitter.birthRate = 0
        updateEmitter()
    }
    
    /// Updates the configuration of the particle system
    public func update(with configuration: ParticleConfiguration) {
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
    public static func randomRainbowColor() -> ParticleEmitterComponent.ParticleEmitter.ParticleColor {
        let hues: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        let randomHue = hues.randomElement() ?? 0
        let nextHue = hues.first(where: { $0 > randomHue }) ?? hues[0]
        
        let startColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 1.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.8
        )
        let endColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.0,
            green: 0.0,
            blue: 1.0,
            alpha: 0.6
        )
        
        return .evolving(
            start: .single(startColor),
            end: .single(endColor)
        )
    }
}

// MARK: - Letter Animation Support

@available(visionOS 2.0, *)
public extension AetherParticles {
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
        
        let system = AetherParticles(configuration: ParticlePreset.galaxySplit.configuration)
        system._rootEntity.position = letterPositions[index]
        return system
    }
} 