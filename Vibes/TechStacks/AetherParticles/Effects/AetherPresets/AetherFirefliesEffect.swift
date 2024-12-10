import RealityKit
import Foundation

/// A particle effect that creates floating, glowing particles reminiscent of fireflies.
/// Features rainbow color transitions, pulsing glow, and organic jellyfish-like movement.
@available(visionOS 2.0, *)
struct AetherFirefliesEffect: EffectsProvider {
    // MARK: - Constants
    
    /// Base colors for the rainbow transition
    private static let rainbowColors: [ParticleEmitterComponent.ParticleEmitter.Color] = [
        .init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8),  // Red
        .init(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8),  // Orange
        .init(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.8),  // Yellow
        .init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.8),  // Green
        .init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.8),  // Blue
        .init(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.8)   // Purple
    ]
    
    /// Movement parameters
    private static let movementParams = MovementParams(
        baseSpeed: 0.1,
        wanderStrength: 0.05,
        pulseFrequency: 0.5,
        pulseAmplitude: 0.02
    )
    
    // MARK: - EffectsProvider Implementation
    
    static var configuration: AetherConfiguration {
        AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: [2, 2, 2],
            birthRate: 500,
            colorConfig: .evolving(
                start: rainbowColors[0],
                end: rainbowColors[1]
            ),
            bounds: AetherParticles.standardBounds,
            acceleration: calculateAcceleration(),
            speed: movementParams.baseSpeed,
            lifetime: 4.0  // Longer lifetime for smoother transitions
        )
    }
    
    static var physicsParams: AetherPhysicsParams {
        .init(
            wanderStrength: movementParams.wanderStrength,
            pulseFrequency: movementParams.pulseFrequency,
            pulseAmplitude: movementParams.pulseAmplitude
        )
    }
    
    static var animationSequence: AetherAnimationSequence? {
        // Create color transition sequence
        let colorSequence = AetherAnimationSequence(
            duration: 10.0,
            repeats: true,
            keyframes: createColorKeyframes()
        )
        
        return colorSequence
    }
    
    // MARK: - Private Helpers
    
    private static func calculateAcceleration() -> SIMD3<Float> {
        // Add slight upward drift with random horizontal movement
        let randomX = Float.random(in: -0.02...0.02)
        let randomZ = Float.random(in: -0.02...0.02)
        return [randomX, 0.01, randomZ]
    }
    
    private static func createColorKeyframes() -> [AetherAnimationSequence.Keyframe] {
        var keyframes: [AetherAnimationSequence.Keyframe] = []
        let stepDuration = 2.0  // Time between color transitions
        
        for (index, color) in rainbowColors.enumerated() {
            let nextColor = rainbowColors[(index + 1) % rainbowColors.count]
            
            let keyframe = AetherAnimationSequence.Keyframe(
                time: Double(index) * stepDuration,
                value: .color(start: color, end: nextColor)
            )
            keyframes.append(keyframe)
        }
        
        return keyframes
    }
}

// MARK: - Supporting Types

private struct MovementParams {
    let baseSpeed: Float
    let wanderStrength: Float
    let pulseFrequency: Float
    let pulseAmplitude: Float
} 