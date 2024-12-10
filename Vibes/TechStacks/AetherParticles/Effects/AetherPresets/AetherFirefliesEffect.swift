import RealityKit
import Foundation
import SwiftUI

/// A particle effect that creates floating, glowing particles reminiscent of fireflies.
/// Perfect for creating a magical, ethereal atmosphere.
@available(visionOS 2.0, *)
struct AetherFirefliesEffect {
    // MARK: - Constants
    
    /// Base colors for the rainbow transition
    private static let rainbowColors: [(Color, Color)] = [
        (.red, .orange),
        (.orange, .yellow),
        (.yellow, .green),
        (.green, .blue),
        (.blue, .purple),
        (.purple, .red)
    ]
    
    /// Pulse parameters for glow effect
    private static let pulseFrequency: Float = 0.5  // Slower pulse
    private static let pulseAmplitude: Float = 0.3  // Moderate glow variation
    
    /// Creates a configuration for the fireflies effect
    static func makeConfiguration() -> AetherConfiguration {
        // Get pulse motion for glow intensity
        let pulseMotion = AetherPhysics.pulse(
            at: Date().timeIntervalSinceReferenceDate,
            frequency: pulseFrequency,
            amplitude: pulseAmplitude
        )
        
        // Use y component of pulse for glow intensity
        let glowIntensity = 0.8 + pulseMotion.y  // Base alpha 0.8 + pulse
        
        // Pick a random pair of colors to transition between
        let (startSwiftUIColor, endSwiftUIColor) = rainbowColors.randomElement()!
        
        // Convert SwiftUI colors to particle colors
        let startColor = ParticleEmitterComponent.ParticleEmitter.Color(startSwiftUIColor)
        let endColor = ParticleEmitterComponent.ParticleEmitter.Color(endSwiftUIColor)
        
        // Create evolving color configuration
        let startColorValue = ParticleEmitterComponent.ParticleEmitter.ParticleColor.ColorValue.single(startColor)
        let endColorValue = ParticleEmitterComponent.ParticleEmitter.ParticleColor.ColorValue.single(endColor)
        let evolvingColor = ParticleEmitterComponent.ParticleEmitter.ParticleColor.evolving(
            start: startColorValue,
            end: endColorValue
        )
        
        return AetherConfiguration(
            emitterShape: .sphere,
            emitterSize: [2, 2, 2],
            birthRate: 500,
            colorConfig: evolvingColor,
            bounds: AetherParticles.standardBounds,
            // Gentle floating movement
            acceleration: [
                Float.random(in: -0.01...0.01),  // Tiny x force
                Float.random(in: -0.01...0.01),  // Tiny y force
                Float.random(in: -0.01...0.01)   // Tiny z force
            ],
            speed: 0.05,  // Very slow, drifting movement
            lifetime: 6.0  // Longer lifetime for smoother transitions
        )
    }
} 