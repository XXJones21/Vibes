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
    required init(scene: Scene) { }
    
    /// Register the nexus particle system with RealityKit.
    /// This should be called when your app launches.
    static func registerSystem() {
        guard !isRegistered else { return }
        
        if #available(visionOS 2.0, *) {
            do {
                try RealityKit.Scene.registerSystem(Self.self)
                isRegistered = true
            } catch {
                print("Failed to register NexusSystem: \(error)")
            }
        }
    }
    
    /// Unregister the nexus particle system.
    /// This should be called when your app is terminating.
    static func unregisterSystem() {
        guard isRegistered else { return }
        isRegistered = false
    }
    
    /// Update the system - called every frame
    func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for nexusEntity in context.entities(matching: Self.nexusQuery, updatingSystemWhen: .rendering) {
            guard let emitter = nexusEntity.components[ParticleEmitterComponent.self] else { continue }
            
            // Update particle behavior based on nexus settings
            if let nexusComponent = nexusEntity.components[NexusComponent.self] {
                updateNexusEmitter(emitter, with: nexusComponent, deltaTime: deltaTime)
            }
            
            // Apply updated emitter
            nexusEntity.components[ParticleEmitterComponent.self] = emitter
        }
    }
    
    private func updateNexusEmitter(_ emitter: ParticleEmitterComponent, with nexus: NexusComponent, deltaTime: TimeInterval) {
        // Update particle behavior based on nexus component
        // This is where we implement complex physics, interactions, etc.
        
        // Example: Update birth rate based on music intensity
        emitter.mainEmitter.birthRate = nexus.baseBirthRate * nexus.intensity
        
        // Example: Update particle velocities for swirling effect
        let swirl = SIMD3<Float>(
            cos(Float(lastUpdateTime)) * nexus.intensity,
            sin(Float(lastUpdateTime)) * nexus.intensity,
            0
        )
        emitter.mainEmitter.acceleration = nexus.baseAcceleration + swirl
    }
} 