import RealityKit
import Foundation

/// Manages small, synchronized particle effects for album visualizations
@available(visionOS 2.0, *)
public class PulseSystem: System {
    // MARK: - Static Properties
    
    /// Query to find all pulse particle emitters
    private static let pulseQuery = EntityQuery(where: .has(PulseComponent.self))
    
    /// Whether the system has been registered
    @MainActor
    public private(set) static var isRegistered = false
    
    /// System dependencies
    public static var dependencies: [SystemDependency] { [] }
    
    // MARK: - Properties
    
    /// Last update timestamp for delta time calculation
    private var lastUpdateTime: TimeInterval = 0
    
    // MARK: - Initialization
    
    /// Initialize the system
    public required init(scene: Scene) {
        print("PulseSystem: Initialized")
    }
    
    // MARK: - System Registration
    
    /// Register the Pulse particle system.
    /// This is automatically called when a PulseComponent is created.
    @MainActor
    public static func registerSystem() {
        guard !isRegistered else { return }
        isRegistered = true
        print("PulseSystem: Successfully registered")
    }
    
    /// Unregister the Pulse particle system.
    @MainActor
    public static func unregisterSystem() {
        guard isRegistered else { return }
        isRegistered = false
        print("PulseSystem: Successfully unregistered")
    }
    
    // MARK: - Update
    
    /// Update the system - called every frame
    public func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for entity in context.scene.performQuery(Self.pulseQuery) {
            guard let emitter = entity.components[ParticleEmitterComponent.self],
                  let pulseComponent = entity.components[PulseComponent.self] else { continue }
            
            // Update particle behavior based on pulse settings
            updatePulseEmitter(entity: entity, emitter: emitter, pulse: pulseComponent, deltaTime: deltaTime)
        }
    }
    
    // MARK: - Private Methods
    
    private func updatePulseEmitter(entity: Entity, emitter: ParticleEmitterComponent, pulse: PulseComponent, deltaTime: TimeInterval) {
        // Create new configuration with current settings
        var newEmitter = emitter
        newEmitter.mainEmitter.birthRate = pulse.baseBirthRate * pulse.intensity
        newEmitter.mainEmitter.size = pulse.baseSize
        newEmitter.mainEmitter.color = pulse.colorConfig
        newEmitter.mainEmitter.lifeSpan = Double(pulse.baseLifetime)
        
        // Apply updated emitter
        entity.components[ParticleEmitterComponent.self] = newEmitter
    }
} 