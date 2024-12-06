import RealityKit
import SwiftUI

/// A particle system manager for visionOS applications.
/// This class provides a high-level interface for creating and managing particle effects.
@available(visionOS 1.0, *)
public class ParticleSystem: ObservableObject {
    // MARK: - Public Properties
    
    /// The root entity that hosts the particle emitter
    public private(set) var rootEntity: Entity
    
    /// The current state of the particle system
    @Published public private(set) var state: ParticleState = .inactive
    
    // MARK: - Private Properties
    
    /// The main particle emitter component
    private var emitterComponent: ParticleEmitterComponent
    
    /// The current configuration of the particle system
    private var configuration: ParticleConfiguration
    
    // MARK: - Types
    
    /// Represents the current state of the particle system
    public enum ParticleState {
        case inactive
        case active
        case transitioning
        case complete
    }
    
    /// Configuration for the particle system
    public struct ParticleConfiguration {
        /// The shape of the particle emitter
        public var emitterShape: ParticleEmitterComponent.EmitterShape
        
        /// The size of the emitter shape
        public var emitterSize: SIMD3<Float>
        
        /// The rate at which new particles are created
        public var birthRate: Float
        
        /// The initial color configuration for particles
        public var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
        
        /// The bounds in which particles can exist
        public var bounds: BoundingBox
        
        /// The acceleration applied to particles
        public var acceleration: SIMD3<Float>
        
        /// The speed of particle movement
        public var speed: Float
        
        /// Creates a default configuration
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
    
    /// Creates a new particle system with the specified configuration
    public init(configuration: ParticleConfiguration = .default) {
        self.configuration = configuration
        self.rootEntity = Entity()
        self.emitterComponent = ParticleEmitterComponent()
        
        setupEmitter()
    }
    
    // MARK: - Public Methods
    
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
        rootEntity.components.set(emitterComponent)
        
        // Position within bounds
        rootEntity.position = [0, 0, 0]
    }
    
    private func updateEmitter() {
        rootEntity.components.set(emitterComponent)
    }
    
    // Helper for rainbow colors
    private static func randomRainbowColor() -> ParticleEmitterComponent.ParticleEmitter.ParticleColor {
        let hues: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        let randomHue = hues.randomElement() ?? 0
        let nextHue = hues.first(where: { $0 > randomHue }) ?? hues[0]
        
        let startColor = UIColor(hue: randomHue, saturation: 1.0, brightness: 1.0, alpha: 0.8)
        let endColor = UIColor(hue: nextHue, saturation: 1.0, brightness: 1.0, alpha: 0.6)
        
        return .evolving(
            start: .single(startColor),
            end: .single(endColor)
        )
    }
}

// MARK: - Convenience Extensions

@available(visionOS 1.0, *)
public extension ParticleSystem {
    /// Creates a particle system with a specific preset configuration
    static func withPreset(_ preset: ParticlePreset) -> ParticleSystem {
        ParticleSystem(configuration: preset.configuration)
    }
}

/// Available particle system presets
@available(visionOS 2.0, *)
public enum ParticlePreset {
    case fireflies
    case sparkles
    case smoke
    case rain
    case galaxy
    case galaxySplit
    
    var configuration: ParticleSystem.ParticleConfiguration {
        switch self {
        case .fireflies:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [4, 4, 4],
                birthRate: 150,
                colorConfig: ParticleSystem.randomRainbowColor(),
                bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, 0.1, 0],
                speed: 0.2
            )
            
        case .galaxy:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [6, 6, 6],
                birthRate: 0, // Using existing particles
                colorConfig: .evolving(
                    start: .single(.systemPurple.withAlphaComponent(0.8)),
                    end: .single(.systemBlue.withAlphaComponent(0.6))
                ),
                bounds: BoundingBox(min: [-8, -8, -8], max: [8, 8, 8]),
                acceleration: [0, 0.1, -0.5], // Gentle spiral inward
                speed: 0.3
            )
            
        case .galaxySplit:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [1.5, 1.5, 1.5],
                birthRate: 0,
                colorConfig: .evolving(
                    start: .single(.systemPurple.withAlphaComponent(0.9)),
                    end: .single(.systemBlue.withAlphaComponent(0.7))
                ),
                bounds: BoundingBox(min: [-3, -3, -3], max: [3, 3, 3]),
                acceleration: [0, 0.05, 0], // Gentle upward drift
                speed: 0.2
            )
            
        case .sparkles:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .point,
                emitterSize: [0.1, 0.1, 0.1],
                birthRate: 200,
                colorConfig: .constant(.single(.white)),
                bounds: BoundingBox(min: [-3, -3, -3], max: [3, 3, 3]),
                acceleration: [0, -0.5, 0],
                speed: 0.5
            )
            
        case .smoke:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [1, 1, 1],
                birthRate: 50,
                colorConfig: .evolving(
                    start: .single(.white.withAlphaComponent(0.4)),
                    end: .single(.white.withAlphaComponent(0))
                ),
                bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, 0.2, 0],
                speed: 0.1
            )
            
        case .rain:
            return ParticleSystem.ParticleConfiguration(
                emitterShape: .plane,
                emitterSize: [10, 0.1, 10],
                birthRate: 300,
                colorConfig: .constant(.single(.white.withAlphaComponent(0.3))),
                bounds: BoundingBox(min: [-10, -10, -10], max: [10, 10, 10]),
                acceleration: [0, -2.0, 0],
                speed: 1.0
            )
        }
    }
}

// Add helper for split positions
@available(visionOS 2.0, *)
public extension ParticleSystem {
    static let letterPositions: [SIMD3<Float>] = [
        [-0.4, 0, 0],  // V
        [-0.2, 0, 0],  // I
        [0.0, 0.1, 0], // B - slightly higher
        [0.2, 0, 0],   // E
        [0.4, 0, 0]    // S
    ]
    
    /// Creates a system for a specific letter position
    static func forLetterPosition(_ index: Int) -> ParticleSystem {
        let system = ParticleSystem(configuration: ParticlePreset.galaxySplit.configuration)
        system.rootEntity.position = letterPositions[index]
        return system
    }
} 