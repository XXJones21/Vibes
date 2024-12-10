import RealityKit

// Import core types
import struct AetherParticles.AetherConfiguration
import struct AetherParticles.AetherPhysicsParams
import struct AetherParticles.AetherAnimationSequence

/// Registry for managing particle effects in the AetherParticles system
@available(visionOS 2.0, *)
final class EffectsRegistry {
    /// Shared instance for global access
    static let shared = EffectsRegistry()
    
    /// Types of effects that can be registered
    enum EffectType {
        case preset(String)      // Static configurations
        case visualizer(String)  // Music-reactive effects
        case animation(String)   // Time-based sequences
    }
    
    /// Storage for registered effects
    private var effects: [String: EffectsProvider.Type] = [:]
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Register a new effect
    /// - Parameters:
    ///   - effect: The effect provider type to register
    ///   - key: Unique identifier for the effect
    func register(_ effect: EffectsProvider.Type, for key: String) {
        effects[key] = effect
    }
    
    /// Retrieve an effect's configuration
    /// - Parameter key: The unique identifier of the effect
    /// - Returns: The effect's configuration if found
    func configuration(for key: String) -> AetherConfiguration? {
        return effects[key]?.configuration
    }
    
    /// Retrieve an effect's physics parameters
    /// - Parameter key: The unique identifier of the effect
    /// - Returns: The effect's physics parameters if found
    func physicsParams(for key: String) -> AetherPhysicsParams? {
        return effects[key]?.physicsParams
    }
    
    /// Retrieve an effect's animation sequence
    /// - Parameter key: The unique identifier of the effect
    /// - Returns: The effect's animation sequence if found
    func animationSequence(for key: String) -> AetherAnimationSequence? {
        return effects[key]?.animationSequence
    }
    
    /// Call the willStart lifecycle hook for an effect
    /// - Parameter key: The unique identifier of the effect
    func willStart(key: String) {
        effects[key]?.willStart()
    }
    
    /// Call the didStop lifecycle hook for an effect
    /// - Parameter key: The unique identifier of the effect
    func didStop(key: String) {
        effects[key]?.didStop()
    }
} 