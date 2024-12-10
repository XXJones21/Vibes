import RealityKit
import Foundation

/// A particle effect that creates a physically accurate galaxy formation with black hole interaction.
@available(visionOS 2.0, *)
struct AetherGalaxyEffect: EffectsProvider {
    // MARK: - Physical Constants
    
    /// Light year in meters
    private static let lightYear: Float = 9.4607e15
    
    /// Gravitational constant
    private static let G: Float = 6.673e-11
    
    /// Typical star mass in kg
    private static let typicalStarMass: Float = 2.0e30
    
    /// Black hole mass (7000x typical star)
    private static let blackHoleMass: Float = typicalStarMass * 7000
    
    /// Gravity smoothing factor to prevent singularities
    private static let gravityEpsilon: Float = 3.0e19
    
    /// Universe scale factor for visualization (1 unit = 1000 light years)
    private static let universeScale: Float = 0.001
    
    // MARK: - EffectsProvider Implementation
    
    static var configuration: AetherConfiguration {
        // Scale velocities and distances
        let typicalStarSpeed = 0.8 * 7.0e10 * universeScale
        let scaledEmitterSize = SIMD3<Float>(4300, 100, 4300) * universeScale
        
        return AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: scaledEmitterSize,  // Now properly scaled
            birthRate: 500,
            colorConfig: .evolving(
                start: .init(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8),  // Purple
                end: .init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6)     // Blue
            ),
            bounds: AetherParticles.standardBounds,
            acceleration: calculateGalaxyAcceleration(),
            speed: typicalStarSpeed,
            lifetime: 10.0  // Longer lifespan for stable orbits
        )
    }
    
    static var physicsParams: AetherPhysicsParams {
        .init(
            gravityStrength: G * blackHoleMass * universeScale,  // Scale the force
            gravityEpsilon: gravityEpsilon * universeScale,      // Scale the smoothing
            universeScale: universeScale
        )
    }
    
    // MARK: - Physics Calculations
    
    private static func calculateGalaxyAcceleration() -> SIMD3<Float> {
        // Calculate force from black hole with proper scaling
        let blackHolePosition = SIMD3<Float>(0, 0, 0)
        let force = (G * blackHoleMass / pow(gravityEpsilon, 2)) * universeScale
        
        // Direction towards black hole
        let direction = normalize(-blackHolePosition)
        
        return direction * force
    }
    
    private static func calculateDarkMatterForce(_ coefficient: Float) -> SIMD3<Float> {
        // Simplified dark matter halo model with proper scaling
        let haloRadius: Float = 2000 * universeScale  // Scale the radius
        let haloStrength = coefficient * typicalStarMass * universeScale  // Scale the force
        
        // Force decreases linearly with radius
        let radialForce = SIMD3<Float>(1, 0, 1) * haloStrength / haloRadius
        
        return radialForce
    }
}

/// Particle modifier for custom behaviors
struct ParticleModifier {
    var position: SIMD3<Float>
    var velocity: SIMD3<Float>
    var mass: Float
    var lifetime: Float
} 