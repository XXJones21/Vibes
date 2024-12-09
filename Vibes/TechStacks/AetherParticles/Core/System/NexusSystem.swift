import RealityKit
import Foundation

/// A RealityKit System that manages large-scale particle effects and immersive visualizations
@available(visionOS 2.0, *)
public class NexusSystem: System {
    // MARK: - Static Properties
    
    /// Query to find all nexus particle emitters
    private static let nexusQuery = EntityQuery(where: .has(NexusComponent.self))
    
    /// Whether the system has been registered
    @MainActor
    public private(set) static var isRegistered = false
    
    /// System dependencies
    public static var dependencies: [SystemDependency] { [] }
    
    /// Last update timestamp for delta time calculation
    private var lastUpdateTime: TimeInterval = 0
    
    // MARK: - Initialization
    
    /// Initialize the system
    public required init(scene: Scene) {
        print("NexusSystem: Initialized")
    }
    
    // MARK: - System Registration
    
    /// Register the Nexus particle system.
    /// This is automatically called when a NexusComponent is created.
    @MainActor
    public static func registerSystem() {
        guard !isRegistered else { return }
        isRegistered = true
        print("NexusSystem: Successfully registered")
    }
    
    /// Unregister the Nexus particle system.
    @MainActor
    public static func unregisterSystem() {
        guard isRegistered else { return }
        isRegistered = false
        print("NexusSystem: Successfully unregistered")
    }
    
    // MARK: - Update
    
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
            updateNexusEmitter(entity: entity, emitter: emitter, nexus: nexusComponent, deltaTime: deltaTime)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateNexusEmitter(entity: Entity, emitter: ParticleEmitterComponent, nexus: NexusComponent, deltaTime: TimeInterval) {
        // Create new configuration with current settings
        var newEmitter = emitter
        newEmitter.mainEmitter.birthRate = nexus.baseBirthRate * nexus.intensity
        newEmitter.mainEmitter.size = nexus.baseSize
        newEmitter.mainEmitter.color = nexus.colorConfig
        newEmitter.mainEmitter.lifeSpan = Double(nexus.baseLifetime)
        newEmitter.speed = nexus.baseVelocity
        
        // Apply physics based on component settings
        let motion = AetherPhysics.spiral(
            at: lastUpdateTime,
            intensity: nexus.intensity,
            inwardPull: nexus.physicsParams.centerAttraction
        )
        
        newEmitter.mainEmitter.acceleration = nexus.baseAcceleration + motion
        
        // Apply updated emitter
        entity.components[ParticleEmitterComponent.self] = newEmitter
    }
} 
