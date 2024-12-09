import RealityKit
import Foundation

/// A RealityKit System that manages large-scale particle effects and immersive visualizations
@available(visionOS 2.0, *)
class NexusSystem: System {
    /// Query to find all nexus particle emitters
    private static let nexusQuery = EntityQuery(where: .has(NexusComponent.self))
    
    /// Last update timestamp for delta time calculation
    private var lastUpdateTime: TimeInterval = 0
    
    /// Whether the system has been registered
    private(set) static var isRegistered = false
    
    /// System dependencies
    static var dependencies: [SystemDependency] {
        []
    }
    
    /// Initialize the system
    required init(scene: Scene) {
        guard !Self.isRegistered else { return }
        
        if #available(visionOS 2.0, *) {
            do {
                try scene.registerSystem(Self.self)
                Self.isRegistered = true
                print("NexusSystem: Successfully registered with scene")
            } catch {
                print("NexusSystem: Failed to register - \(error)")
            }
        }
    }
    
    /// Update the system - called every frame
    func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for entity in context.scene.performQuery(Self.nexusQuery) {
            guard let emitter = entity.components[ParticleEmitterComponent.self] else { continue }
            
            // Update particle behavior based on nexus settings
            if let nexusComponent = entity.components[NexusComponent.self] {
                updateNexusEmitter(entity: entity, emitter: emitter, with: nexusComponent, deltaTime: deltaTime)
            }
        }
    }
    
    private func updateNexusEmitter(entity: Entity, emitter: ParticleEmitterComponent, with nexus: NexusComponent, deltaTime: TimeInterval) {
        // Create new configuration with current settings
        let newConfig = ParticleEmitterComponent.ParticleEmitter(
            birthRate: nexus.baseBirthRate * nexus.intensity,
            size: nexus.baseSize,
            color: nexus.colorConfig,
            lifetime: nexus.baseLifetime,
            velocity: nexus.baseVelocity
        )
        
        // Apply physics based on component settings
        let motion = AetherPhysics.spiral(
            at: lastUpdateTime,
            intensity: nexus.intensity,
            inwardPull: nexus.physicsParams.centerAttraction
        )
        
        newConfig.acceleration = nexus.baseAcceleration + motion
        
        // Create new emitter with updated config
        let updatedEmitter = ParticleEmitterComponent(from: newConfig)
        
        // Apply updated emitter
        entity.components[ParticleEmitterComponent.self] = updatedEmitter
    }
} 