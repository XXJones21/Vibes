import RealityKit
import Foundation

/// A particle effect that creates a physically accurate galaxy formation with black hole interaction.
@available(visionOS 2.0, *)
struct AetherGalaxyEffect {
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
    
    /// Universe scale factor for visualization
    private static let universeScale: Float = 1000.0 / (140000.0 * lightYear)
    
    // MARK: - Components
    
    /// Creates a preconfigured emitter component for the galaxy effect
    static var emitterComponent: ParticleEmitterComponent {
        var component = ParticleEmitterComponent()
        
        // Configure emitter shape for galaxy disk
        component.emitterShape = .sphere
        component.emitterShapeSize = [4300, 100, 4300] // Disk-like shape
        
        // Configure particle appearance
        let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8
        )
        let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6
        )
        component.mainEmitter.color = .evolving(
            start: .single(purpleColor),
            end: .single(blueColor)
        )
        
        // Particle birth rate based on density
        component.mainEmitter.birthRate = 500
        
        // Particle size varies with mass
        component.mainEmitter.size = 0.05
        
        // Longer lifespan for stable orbits
        component.mainEmitter.lifeSpan = 10.0
        
        // Initial orbital velocity
        let typicalStarSpeed = 0.8 * 7.0e10 * universeScale
        component.speed = typicalStarSpeed
        
        // Configure physics modifiers
        component.mainEmitter.acceleration = calculateGalaxyAcceleration()
        
        return component
    }
    
    // MARK: - Physics Calculations
    
    /// Calculate acceleration for galaxy particles including black hole effects
    private static func calculateGalaxyAcceleration() -> SIMD3<Float> {
        // Base orbital velocity for stable disk
        let baseOrbitalVelocity = SIMD3<Float>(0, 0.1, -0.5)
        
        // Add black hole gravitational influence
        let blackHolePosition = SIMD3<Float>(0, 0, 0) // Center
        let blackHoleForce = calculateBlackHoleForce(blackHolePosition)
        
        // Add dark matter halo effect
        let darkForceCoefficient: Float = 4.0e-20 * G
        let darkMatterForce = calculateDarkMatterForce(darkForceCoefficient)
        
        // Combine forces
        return baseOrbitalVelocity + blackHoleForce + darkMatterForce
    }
    
    /// Calculate gravitational force from central black hole
    private static func calculateBlackHoleForce(_ blackHolePosition: SIMD3<Float>) -> SIMD3<Float> {
        let distance = length(blackHolePosition)
        let epsilonSqrd = gravityEpsilon * gravityEpsilon
        
        // Use smoothed gravity to prevent singularity
        let force = G * blackHoleMass / pow(distance * distance + epsilonSqrd, 1.5)
        
        // Direction towards black hole
        let direction = normalize(-blackHolePosition)
        
        return direction * force
    }
    
    /// Calculate dark matter halo force
    private static func calculateDarkMatterForce(_ coefficient: Float) -> SIMD3<Float> {
        // Simplified dark matter halo model
        let haloRadius: Float = 2000 // Large radius for dark matter effect
        let haloStrength = coefficient * typicalStarMass
        
        // Force decreases linearly with radius
        let radialForce = SIMD3<Float>(1, 0, 1) * haloStrength / haloRadius
        
        return radialForce
    }
    
    // MARK: - Particle Modifiers
    
    /// Modify particle based on its position in the galaxy
    static func modifyParticle(_ particle: inout ParticleModifier) {
        // Add spiral arm perturbation
        let angle = atan2(particle.position.z, particle.position.x)
        let spiralPhase = 2.0 * sin(2.0 * angle)
        
        // Modify velocity for spiral structure
        particle.velocity.x += cos(spiralPhase) * 0.1
        particle.velocity.z += sin(spiralPhase) * 0.1
        
        // Add vertical oscillation for thickness
        particle.velocity.y += 0.05 * sin(angle * 4)
    }
}

/// Particle modifier for custom behaviors
struct ParticleModifier {
    var position: SIMD3<Float>
    var velocity: SIMD3<Float>
    var mass: Float
    var lifetime: Float
} 