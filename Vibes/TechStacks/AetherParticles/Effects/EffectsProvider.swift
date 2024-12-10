import RealityKit
import Foundation

/// Protocol defining the requirements for particle effects in the AetherParticles system
@available(visionOS 2.0, *)
protocol EffectsProvider {
    /// The base configuration for the effect
    static var configuration: AetherConfiguration { get }
    
    /// Physics parameters for the effect (optional)
    static var physicsParams: AetherPhysicsParams { get }
    
    /// Animation sequence for the effect (optional)
    static var animationSequence: AetherAnimationSequence? { get }
    
    /// Called before the effect starts (optional)
    static func willStart()
    
    /// Called after the effect stops (optional)
    static func didStop()
}

/// Default implementations for optional requirements
@available(visionOS 2.0, *)
extension EffectsProvider {
    static var physicsParams: AetherPhysicsParams {
        .default
    }
    
    static var animationSequence: AetherAnimationSequence? {
        nil
    }
    
    static func willStart() {}
    static func didStop() {}
} 