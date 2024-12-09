import SwiftUI
import RealityKit
import Combine
import _RealityKit_SwiftUI

/// Private state management class for AetherParticlesView
@available(visionOS 2.0, *)
private final class AetherParticlesState: ObservableObject {
    // MARK: - Properties
    
    /// The particle system instance
    private let particles: AetherParticles
    
    /// Whether this is a large-scale effect using NexusSystem
    let isLargeScale: Bool
    
    /// The current configuration
    private var configuration: AetherParticles.AetherConfiguration
    
    /// Callback for state changes
    private var stateChanged: ((AetherParticles.AetherState) -> Void)?
    
    /// The current state of the particle system
    @Published private(set) var state: AetherParticles.AetherState = .inactive
    
    /// The root entity containing the particle system
    var rootEntity: Entity { particles.rootEntity }
    
    // MARK: - Initialization
    
    init(
        preset: AetherParticles.AetherPreset,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((AetherParticles.AetherState) -> Void)? = nil
    ) {
        self.isLargeScale = isLargeScale
        self.stateChanged = stateChanged
        
        // Get configuration from preset
        let config = preset.configuration
        self.configuration = config
        
        // Create particle system
        self.particles = AetherParticles(
            configuration: config,
            isLargeScale: isLargeScale
        )
        
        // Update physics params if using NexusSystem
        if isLargeScale {
            updatePhysicsParams(physicsParams)
        }
        
        // Setup state observation
        setupStateObservation()
    }
    
    init(
        configuration: AetherParticles.AetherConfiguration,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((AetherParticles.AetherState) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.isLargeScale = isLargeScale
        self.stateChanged = stateChanged
        
        // Create particle system
        self.particles = AetherParticles(
            configuration: configuration,
            isLargeScale: isLargeScale
        )
        
        // Update physics params if using NexusSystem
        if isLargeScale {
            updatePhysicsParams(physicsParams)
        }
        
        // Setup state observation
        setupStateObservation()
    }
    
    // MARK: - Methods
    
    func start() {
        print("🎵 Particle System: Starting")
        print("🎵 Current State: \(state)")
        particles.start()
    }
    
    func stop() {
        print("🎵 Particle System: Stopping")
        print("🎵 Final State: \(state)")
        particles.stop()
    }
    
    func update() {
        print("🎵 Particle System: Updating")
        print("🎵 State Before Update: \(state)")
        particles.update(with: configuration)
    }
    
    // MARK: - Private Methods
    
    /// Setup state change observation
    private func setupStateObservation() {
        print("🎵 Setting up state observation")
        // Observe particle system state
        if let publisher = self.particles.objectWillChange as? ObservableObjectPublisher {
            publisher.sink { [weak self] _ in
                guard let self = self else { return }
                let newState = self.particles.state
                if newState != state {
                    print("🎵 State Changed: \(state) -> \(newState)")
                    state = newState
                    stateChanged?(newState)
                }
            }
        }
    }
    
    /// Update physics parameters for NexusSystem
    private func updatePhysicsParams(_ params: NexusPhysicsParams) {
        guard isLargeScale,
              let entity = particles.rootEntity.components[NexusComponent.self] else { return }
        
        // Update physics parameters
        var component = entity
        component.physicsParams = params
        particles.rootEntity.components[NexusComponent.self] = component
    }
}

/// A SwiftUI view that wraps AetherParticles for use in both 2D and volumetric contexts
@available(visionOS 2.0, *)
public struct AetherParticlesView: View {
    // MARK: - Type Aliases
    
    /// Re-export types from AetherParticles for convenience
    public typealias State = AetherParticles.AetherState
    public typealias Preset = AetherParticles.AetherPreset
    
    // MARK: - Properties
    
    @StateObject private var state: AetherParticlesState
    
    // MARK: - Initialization
    
    /// Initialize with a preset configuration
    public init(
        preset: Preset,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((State) -> Void)? = nil
    ) {
        _state = StateObject(wrappedValue: AetherParticlesState(
            preset: preset,
            isLargeScale: isLargeScale,
            physicsParams: physicsParams,
            stateChanged: stateChanged
        ))
    }
    
    /// Initialize with a custom configuration
    public init(
        configuration: AetherParticles.AetherConfiguration,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((State) -> Void)? = nil
    ) {
        _state = StateObject(wrappedValue: AetherParticlesState(
            configuration: configuration,
            isLargeScale: isLargeScale,
            physicsParams: physicsParams,
            stateChanged: stateChanged
        ))
    }
    
    // MARK: - View Body
    
    public var body: some View {
        GeometryReader3D { geometry in
            RealityView { [state] content in
                // Create root entity
                let entity = Entity()
                
                // Convert view size to scene space
                let viewSize = content.convert(geometry.size, from: .local, to: .scene)
                let scenePosition = SIMD3<Float>(x: 0, y: viewSize.height * 0.5, z: -2)
                
                if state.isLargeScale {
                    print("🌌 Creating Nexus debug sphere")
                    let sphere = ModelEntity(
                        mesh: .generateSphere(radius: 0.2),
                        materials: [SimpleMaterial(color: .purple, isMetallic: true)]
                    )
                    sphere.position = scenePosition
                    entity.addChild(sphere)
                } else {
                    print("✨ Creating Pulse debug cube")
                    let cube = ModelEntity(
                        mesh: .generateBox(size: 0.2),
                        materials: [SimpleMaterial(color: .blue, isMetallic: false)]
                    )
                    cube.position = scenePosition
                    entity.addChild(cube)
                }
                
                // Position particle system at center
                let particleEntity = state.rootEntity
                particleEntity.position = scenePosition
                entity.addChild(particleEntity)
                
                print("🎯 View size: \(viewSize)")
                print("🎯 Scene position: \(scenePosition)")
                print("🎯 Entity positioned at: \(entity.position)")
                print("🎯 Primitive positioned at: \(state.isLargeScale ? "sphere: " : "cube: ")\(entity.children.first?.position ?? .zero)")
                print("🎯 Particle system positioned at: \(particleEntity.position)")
                
                content.add(entity)
            } update: { content in
                state.update()
            }
        }
        .task {
            state.start()
        }
        .onDisappear {
            state.stop()
        }
    }
}

// MARK: - Preview

#Preview {
    AetherParticlesView(preset: .galaxy)
} 