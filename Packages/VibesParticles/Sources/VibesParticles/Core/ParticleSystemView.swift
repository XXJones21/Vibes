import SwiftUI
import RealityKit

/// A SwiftUI view that wraps a particle system for easy integration
@available(visionOS 1.0, *)
public struct ParticleSystemView: View {
    @StateObject private var particleSystem: ParticleSystem
    private let onStateChange: ((ParticleSystem.ParticleState) -> Void)?
    
    /// Creates a new particle system view
    /// - Parameters:
    ///   - configuration: The configuration for the particle system
    ///   - onStateChange: Optional callback for state changes
    public init(
        configuration: ParticleSystem.ParticleConfiguration = .default,
        onStateChange: ((ParticleSystem.ParticleState) -> Void)? = nil
    ) {
        _particleSystem = StateObject(wrappedValue: ParticleSystem(configuration: configuration))
        self.onStateChange = onStateChange
    }
    
    /// Creates a new particle system view with a preset
    /// - Parameters:
    ///   - preset: The preset configuration to use
    ///   - onStateChange: Optional callback for state changes
    public init(
        preset: ParticlePreset,
        onStateChange: ((ParticleSystem.ParticleState) -> Void)? = nil
    ) {
        _particleSystem = StateObject(wrappedValue: .withPreset(preset))
        self.onStateChange = onStateChange
    }
    
    public var body: some View {
        RealityView { content in
            content.add(particleSystem.rootEntity)
        }
        .onChange(of: particleSystem.state) { _, newState in
            onStateChange?(newState)
        }
        .task {
            particleSystem.start()
        }
    }
    
    /// Starts the particle system
    public func start() {
        particleSystem.start()
    }
    
    /// Pauses the particle system
    public func pause() {
        particleSystem.pause()
    }
    
    /// Stops the particle system
    public func stop() {
        particleSystem.stop()
    }
    
    /// Updates the particle system configuration
    public func update(with configuration: ParticleSystem.ParticleConfiguration) {
        particleSystem.update(with: configuration)
    }
} 