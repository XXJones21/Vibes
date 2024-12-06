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
    
    /// System dependencies
    public static var dependencies: [SystemDependency] {
        []
    }
    
    /// Initialize the system
    public required init(scene: Scene) {
        print("VibesParticles: Initialized AetherSystem")
    }
    
    /// Update the system - called every frame
    public func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Debug logging
        print("VibesParticles: System update at time: \(currentTime)")
        
        // Update existing particles
        for particleEntity in context.entities(matching: Self.emitterQuery, updatingSystemWhen: .rendering) {
            guard let emitter = particleEntity.components[ParticleEmitterComponent.self] else { continue }
            
            // The ParticleEmitterComponent handles particle lifecycle automatically
            // We just need to ensure it's properly updated in the scene
            particleEntity.components[ParticleEmitterComponent.self] = emitter
        }
    }
} 