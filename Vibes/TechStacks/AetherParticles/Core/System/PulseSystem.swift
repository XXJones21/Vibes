import RealityKit
import Foundation

/// Manages small, synchronized particle effects for album visualizations
@available(visionOS 2.0, *)
public class PulseSystem {
    // MARK: - Public Properties
    
    /// The root entity that hosts the particle emitter
    public var entity: Entity { _rootEntity }
    private let _rootEntity: Entity
    
    /// The current state of the pulse system
    private(set) var state: PulseState = .inactive
    
    // MARK: - Private Properties
    
    /// The main particle emitter component
    private var emitterComponent: ParticleEmitterComponent
    
    /// The current configuration
    private var configuration: AetherConfiguration
    
    /// Standard bounds for particle systems
    internal static let standardBounds = AetherParticles.standardBounds
    
    // MARK: - Types
    
    /// Represents the current state of the pulse system
    public enum PulseState {
        /// System is not emitting particles
        case inactive
        /// System is actively emitting particles
        case active
        /// System is in the middle of a state change
        case transitioning
    }
    
    // MARK: - Initialization
    
    /// Initialize a new pulse system with the given configuration
    public init(configuration: AetherConfiguration = .pulseDefault) {
        self._rootEntity = Entity()
        self.configuration = configuration
        self.emitterComponent = ParticleEmitterComponent()
        configure(with: configuration)
    }
    
    // MARK: - Public Methods
    
    /// Start emitting particles
    public func start() {
        guard state == .inactive else { return }
        state = .active
        _rootEntity.components[ParticleEmitterComponent.self] = emitterComponent
    }
    
    /// Stop emitting particles
    public func stop() {
        guard state == .active else { return }
        state = .inactive
        _rootEntity.components[ParticleEmitterComponent.self] = nil
    }
    
    /// Update the system with a new configuration
    public func update(with configuration: AetherConfiguration) {
        self.configuration = configuration
        configure(with: configuration)
        
        if state == .active {
            _rootEntity.components[ParticleEmitterComponent.self] = emitterComponent
        }
    }
    
    // MARK: - Private Methods
    
    private func configure(with config: AetherConfiguration) {
        emitterComponent.mainEmitter.birthRate = Float(config.birthRate)
        emitterComponent.mainEmitter.color = config.colorConfig
        emitterComponent.mainEmitter.lifeSpan = Double(config.lifetime)
        emitterComponent.mainEmitter.acceleration = config.acceleration
        emitterComponent.speed = config.speed
        emitterComponent.emitterShape = config.emitterShape
        emitterComponent.emitterShapeSize = config.emitterSize
    }
}

// MARK: - Default Configurations

extension AetherConfiguration {
    /// Default configuration for album pulse effects
    public static var pulseDefault: AetherConfiguration {
        AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: [0.1, 0.1, 0.1],  // Small, album-sized emitter
            birthRate: 100,
            colorConfig: .constant(.single(.white.withAlphaComponent(0.6))),
            bounds: PulseSystem.standardBounds,
            acceleration: [0, 0.05, 0],
            speed: 0.1,
            lifetime: 1.0
        )
    }
} 