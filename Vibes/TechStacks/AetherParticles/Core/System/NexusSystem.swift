import RealityKit
import Foundation

/// A RealityKit System that manages large-scale particle effects and immersive visualizations
@available(visionOS 2.0, *)
public class NexusSystem: System {
    /// Query to find all nexus particle emitters
    private static let nexusQuery = EntityQuery(where: .has(NexusComponent.self))
    
    /// Last update timestamp for delta time calculation
    private var lastUpdateTime: TimeInterval = 0
    
    /// Whether the system has been registered
    @MainActor
    public private(set) static var isRegistered = false
    
    /// System dependencies
    public static var dependencies: [SystemDependency] {
        []
    }
    
    /// Initialize the system
    public required init(scene: Scene) {
        print("NexusSystem: Initialized")
    }
    
    /// Register the Nexus particle system with RealityKit.
    /// This should be called when setting up your immersive space.
    @MainActor
    public static func registerSystem(in scene: Scene) {
        guard !isRegistered else { return }
        
        if #available(visionOS 2.0, *) {
            scene.registerSystem(Self.self)
            isRegistered = true
            print("NexusSystem: Successfully registered")
        }
    }
    
    /// Unregister the Nexus particle system.
    /// This should be called when closing your immersive space.
    @MainActor
    public static func unregisterSystem(from scene: Scene) {
        guard isRegistered else { return }
        scene.unregisterSystem(Self.self)
        isRegistered = false
        print("NexusSystem: Successfully unregistered")
    }
    
    /// Update the system - called every frame
    public func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for entity in context.scene.performQuery(Self.nexusQuery) {
            guard let emitter = entity.components[ParticleEmitterComponent.self],
                  let nexusComponent = entity.components[NexusComponent.self] else { continue }
            
            // Update particle behavior based on nexus settings
            updateNexusEmitter(entity: entity, emitter: emitter, with: nexusComponent, deltaTime: deltaTime)
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