import RealityKit
import Foundation
import QuartzCore
import RealityFoundation

/// A RealityKit System that manages aether particle emission and lifecycle
@available(visionOS 2.0, *)
public class AetherSystem: System {
    /// Query to find all particle emitters
    private static let emitterQuery = EntityQuery(where: .has(ParticleEmitterComponent.self))
    
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
        print("AetherParticles: Initialized AetherSystem")
    }
    
    /// Register the Aether particle system with RealityKit.
    /// This should be called when your app launches, typically in your app's init
    /// or when setting up your first RealityView.
    @MainActor
    public static func registerSystem() {
        guard !isRegistered else { return }
        
        if #available(visionOS 2.0, *) {
            try? RealityKit.SystemRegistry.shared.register(system: AetherSystem.self)
            isRegistered = true
            print("AetherParticles: Successfully registered AetherSystem")
        }
    }
    
    /// Unregister the Aether particle system.
    /// This should be called when your app is terminating or when you no longer need particle effects.
    @MainActor
    public static func unregisterSystem() {
        guard isRegistered else { return }
        RealityKit.SystemRegistry.shared.unregister(system: AetherSystem.self)
        isRegistered = false
        print("AetherParticles: Successfully unregistered AetherSystem")
    }
    
    /// Update the system - called every frame
    public func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for particleEntity in context.entities(matching: Self.emitterQuery, updatingSystemWhen: .rendering) {
            guard let emitter = particleEntity.components[ParticleEmitterComponent.self] else { continue }
            
            // The ParticleEmitterComponent handles particle lifecycle automatically
            // We just need to ensure it's properly updated in the scene
            particleEntity.components[ParticleEmitterComponent.self] = emitter
        }
    }
} 