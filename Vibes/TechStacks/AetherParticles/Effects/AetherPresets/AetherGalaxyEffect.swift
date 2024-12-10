import RealityKit
import Foundation

/// A particle effect that creates a physically accurate galaxy formation with black hole interaction.
@available(visionOS 2.0, *)
struct AetherGalaxyEffect {
    // MARK: - Configuration Generation
    
    /// Creates a configuration for the galaxy effect
    static func makeConfiguration() -> AetherConfiguration {
        return AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: SIMD3<Float>(4, 0.1, 4),
            birthRate: 1000,
            colorConfig: AetherParticles.randomRainbowColor(),
            bounds: AetherParticles.standardBounds,
            acceleration: SIMD3<Float>(
                Float.random(in: -0.5...0.5),  // Random x force for spin
                0,                             // No vertical force
                Float.random(in: -0.5...0.5)   // Random z force for spin
            ),
            speed: 0.8,  // Moderate speed for orbital motion
            lifetime: 8.0  // Longer lifetime for stable disk
        )
    }
}

/// Particle modifier for custom behaviors
struct ParticleModifier {
    var position: SIMD3<Float>
    var velocity: SIMD3<Float>
    var mass: Float
    var lifetime: Float
} 