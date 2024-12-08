import RealityKit
import Foundation
import QuartzCore
import RealityFoundation

/// A RealityKit System that manages aether particle emission and lifecycle
@available(visionOS 2.0, *)
class AetherSystem: System {
    /// Query to find all particle emitters
    private static let emitterQuery = EntityQuery(where: .has(ParticleEmitterComponent.self))
    
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
    
    /// Register the Aether particle system with RealityKit.
    /// This should be called when your app launches.
    static func registerSystem() {
        guard !isRegistered else { return }
        
        if #available(visionOS 2.0, *) {
            do {
                try Scene.registerSystem(AetherSystem.self)
                isRegistered = true
            } catch {
                print("Failed to register AetherSystem: \(error)")
            }
        }
    }
    
    /// Unregister the Aether particle system.
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
        for particleEntity in context.entities(matching: Self.emitterQuery, updatingSystemWhen: .rendering) {
            guard let emitter = particleEntity.components[ParticleEmitterComponent.self] else { continue }
            particleEntity.components[ParticleEmitterComponent.self] = emitter
        }
    }
} 