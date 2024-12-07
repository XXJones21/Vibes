import SwiftUI
import RealityKit

/// A SwiftUI view that wraps an AetherParticles system for easy integration into SwiftUI views.
/// 
/// This view provides a convenient way to add ethereal particle effects to your visionOS app.
/// It handles the RealityKit integration and lifecycle management of the particle system.
///
/// Example usage:
/// ```swift
/// AetherParticlesView(preset: .fireflies) { state in
///     print("Particle state changed to: \(state)")
/// }
/// ```
@available(visionOS 2.0, *)
public struct AetherParticlesView: View {
    @StateObject private var aetherParticles: AetherParticles
    private let onStateChange: ((AetherParticles.ParticleState) -> Void)?
    
    /// Creates a new AetherParticles view with a custom configuration
    /// - Parameters:
    ///   - configuration: The configuration for the particle system
    ///   - onStateChange: Optional callback for state changes
    public init(
        configuration: AetherParticles.ParticleConfiguration = .default,
        onStateChange: ((AetherParticles.ParticleState) -> Void)? = nil
    ) {
        _aetherParticles = StateObject(wrappedValue: AetherParticles(configuration: configuration))
        self.onStateChange = onStateChange
    }
    
    /// Creates a new AetherParticles view with a preset configuration
    /// - Parameters:
    ///   - preset: The preset configuration to use
    ///   - onStateChange: Optional callback for state changes
    public init(
        preset: AetherParticles.ParticlePreset,
        onStateChange: ((AetherParticles.ParticleState) -> Void)? = nil
    ) {
        _aetherParticles = StateObject(wrappedValue: .withPreset(preset))
        self.onStateChange = onStateChange
    }
    
    public var body: some View {
        RealityView { content in
            content.add(aetherParticles.rootEntity)
        }
        .onChange(of: aetherParticles.state) { _, newState in
            onStateChange?(newState)
        }
        .task {
            aetherParticles.start()
        }
    }
    
    /// Starts the particle system
    public func start() {
        aetherParticles.start()
    }
    
    /// Stops the particle system
    public func stop() {
        aetherParticles.stop()
    }
    
    /// Updates the particle system configuration
    public func update(with configuration: AetherParticles.ParticleConfiguration) {
        aetherParticles.update(with: configuration)
    }
} 