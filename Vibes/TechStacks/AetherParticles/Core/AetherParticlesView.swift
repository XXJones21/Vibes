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
    private var configuration: AetherConfiguration
    
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
        configuration: AetherConfiguration,
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
    public typealias AetherState = AetherParticles.AetherState
    public typealias Preset = AetherParticles.AetherPreset
    
    // MARK: - Properties
    
    @StateObject private var state: AetherParticlesState
    
    // MARK: - Initialization
    
    /// Initialize with a preset configuration
    public init(
        preset: Preset,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((AetherState) -> Void)? = nil
    ) {
        print("🎨 Using preset: \(preset)")
        _state = StateObject(wrappedValue: AetherParticlesState(
            preset: preset,
            isLargeScale: isLargeScale,
            physicsParams: physicsParams,
            stateChanged: stateChanged
        ))
    }
    
    /// Initialize with a custom configuration
    public init(
        configuration: AetherConfiguration,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((AetherState) -> Void)? = nil
    ) {
        _state = StateObject(wrappedValue: AetherParticlesState(
            preset: .galaxy,  // Default to galaxy preset for custom configs
            isLargeScale: isLargeScale,
            physicsParams: physicsParams,
            stateChanged: stateChanged
        ))
    }
    
    // MARK: - View Body
    
    public var body: some View {
        GeometryReader3D { geometry in
            RealityView { content in
                // 1. SETUP ENTITY & COMPONENTS
                let entity = Entity()
                
                // 2. ADD TO CONTENT
                content.add(entity)
                
                // 3. COORDINATE SPACE CONVERSION
                let viewSize = content.convert(
                    Size3D(vector: geometry.size.vector),
                    from: .local,
                    to: entity.parent!
                )
                
                // 4. SETUP BOUNDS & POSITIONING
                let boundingBox = BoundingBox(
                    min: [-10, -10, -10],  // 20 meters total (from -10 to +10)
                    max: [10, 10, 10]
                )
                
                // 5. POSITION ENTITY
                //entity.position.z = 0.5  // Position 0.5 meters away on z-axis
                
                // 6. ADD PARTICLE SYSTEM
                let particleEntity = state.rootEntity
                particleEntity.position = entity.position
                entity.addChild(particleEntity)
                
            } update: { content in
                guard let entity = content.entities.first else { return }
                
                // Update bounds
                updateBounds(content, with: geometry.size.vector)
            }
        }
        .task {
            state.start()
        }
        .onDisappear {
            state.stop()
        }
    }
    
    private func updateBounds(_ content: RealityViewContent, with geometryVector: SIMD3<Double>) {
        guard let entity = content.entities.first else { return }
        
        // Create bounds
        let boundingBox = BoundingBox(
            min: [-10, -10, -10],  // 20 meters total (from -10 to +10)
            max: [10, 10, 10]
        )
        
        // Re-center if needed
        if !boundingBox.contains(entity.position) {
            entity.position = [0, 0, 0.0]  // Keep at 2.5 meters on z-axis
        }
    }
}

// MARK: - Preview

#Preview {
    AetherParticlesView(preset: .galaxy)
} 
