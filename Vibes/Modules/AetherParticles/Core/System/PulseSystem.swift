import RealityKit
import Foundation

/// Manages small, synchronized particle effects for album visualizations
@available(visionOS 2.0, *)
class PulseSystem {
    /// Whether the system has been initialized
    private(set) static var isInitialized = false
    
    /// The root anchor for all pulse emitters
    private static var rootAnchor = AnchorEntity()
    
    /// Initialize the pulse system
    static func registerSystem() {
        guard !isInitialized else { return }
        isInitialized = true
    }
    
    /// Cleanup the pulse system
    static func unregisterSystem() {
        guard isInitialized else { return }
        rootAnchor.removeFromParent()
        isInitialized = false
    }
    
    /// Add a pulse emitter to the scene
    static func addEmitter(to scene: RealityKit.Scene) -> Entity {
        let emitter = Entity()
        rootAnchor.addChild(emitter)
        scene.addAnchor(rootAnchor)
        return emitter
    }
    
    /// Configure a pulse emitter with specific settings
    static func configure(_ entity: Entity, with config: PulseConfiguration) {
        var component = ParticleEmitterComponent()
        component.emitterShape = config.shape
        component.emitterShapeSize = config.size
        component.mainEmitter.birthRate = config.birthRate
        component.mainEmitter.color = config.color
        component.mainEmitter.size = config.particleSize
        component.mainEmitter.lifeSpan = config.lifetime
        component.mainEmitter.acceleration = config.acceleration
        component.speed = config.speed
        entity.components.set(component)
    }
    
    /// Remove a pulse emitter from the scene
    static func removeEmitter(_ entity: Entity) {
        entity.removeFromParent()
    }
} 