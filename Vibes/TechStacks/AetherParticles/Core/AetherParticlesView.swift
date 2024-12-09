import SwiftUI
import RealityKit
import Combine

/// A SwiftUI view that wraps AetherParticles for use in both 2D and volumetric contexts
@available(visionOS 2.0, *)
public final class AetherParticlesView: View, ObservableObject {
    // MARK: - Type Aliases
    
    /// Re-export types from AetherParticles for convenience
    public typealias State = AetherParticles.AetherState
    public typealias Preset = AetherParticles.AetherPreset
    
    // MARK: - Properties
    
    /// The particle system instance
    private let particles: AetherParticles
    
    /// Whether this is a large-scale effect using NexusSystem
    private let isLargeScale: Bool
    
    /// The current configuration
    private var configuration: AetherParticles.AetherConfiguration
    
    /// Callback for state changes
    private var stateChanged: ((State) -> Void)?
    
    /// The current state of the particle system
    @Published private(set) var state: State = .inactive
    
    // MARK: - Initialization
    
    /// Initialize with a preset configuration
    /// - Parameters:
    ///   - preset: The particle effect preset to use
    ///   - isLargeScale: Whether this is a large-scale effect using NexusSystem (default: false)
    ///   - physicsParams: Physics parameters for NexusSystem effects (ignored if not large-scale)
    ///   - stateChanged: Optional callback for state changes
    public init(
        preset: Preset,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((State) -> Void)? = nil
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
    
    /// Initialize with a custom configuration
    /// - Parameters:
    ///   - configuration: Custom particle system configuration
    ///   - isLargeScale: Whether this is a large-scale effect using NexusSystem (default: false)
    ///   - physicsParams: Physics parameters for NexusSystem effects (ignored if not large-scale)
    ///   - stateChanged: Optional callback for state changes
    public init(
        configuration: AetherParticles.AetherConfiguration,
        isLargeScale: Bool = false,
        physicsParams: NexusPhysicsParams = .default,
        stateChanged: ((State) -> Void)? = nil
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
    
    // MARK: - View Body
    
    public var body: some View {
        RealityView { content in
            content.add(self.particles.rootEntity)
        } update: { content in
            // Update configuration if needed
            self.particles.update(with: self.configuration)
        }
        .task {
            // Start particles when view appears
            self.particles.start()
        }
        .onDisappear {
            // Stop particles when view disappears
            self.particles.stop()
        }
    }
    
    // MARK: - Private Methods
    
    /// Setup state change observation
    private func setupStateObservation() {
        // Observe particle system state
        if let publisher = self.particles.objectWillChange as? ObservableObjectPublisher {
            publisher.sink { [weak self] _ in
                guard let self = self else { return }
                let newState = self.particles.state
                if newState != state {
                    state = newState
                    stateChanged?(newState)
                }
            }
        }
    }
    
    /// Update the particle system configuration
    private func updateConfiguration() {
        particles.update(with: configuration)
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

// MARK: - Preview

#Preview {
    AetherParticlesView(preset: .galaxy)
} 