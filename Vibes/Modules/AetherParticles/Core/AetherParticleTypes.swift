import RealityKit

/// RealityKit particle type extensions for the AetherParticles system
@available(visionOS 2.0, *)
extension ParticleEmitterComponent.ParticleEmitter {
    typealias AetherColor = RealityKit.ParticleEmitterComponent.ParticleEmitter.Color
    typealias AetherParticleColor = RealityKit.ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// Color configuration modes for Aether particle effects
    enum AetherColorMode {
        /// Single constant color
        case constant(AetherColor)
        /// Color that evolves over particle lifetime
        case evolving(start: AetherColor, end: AetherColor)
        /// Multiple colors for variation
        case multiple([AetherColor])
    }
}

@available(visionOS 2.0, *)
extension ParticleEmitterComponent {
    typealias AetherEmitterShape = RealityKit.ParticleEmitterComponent.EmitterShape
    
    /// Shape configurations for Aether particle emission
    enum AetherShape {
        /// Emit from sphere surface or volume
        case sphere
        /// Emit from a single point
        case point
        /// Emit from a plane surface
        case plane
    }
} 