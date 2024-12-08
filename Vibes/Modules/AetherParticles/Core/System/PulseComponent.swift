import RealityKit

/// Component for storing pulse-specific particle data and behavior
@available(visionOS 2.0, *)
struct PulseComponent: Component {
    /// The current intensity of the pulse (0-1)
    var intensity: Float = 0
    
    /// The base birth rate for particles
    var baseBirthRate: Float = 100
    
    /// The base particle size
    var baseSize: Float = 0.05
    
    /// The base particle lifetime
    var baseLifetime: Float = 1.0
    
    /// The pulse frequency in Hz
    var frequency: Float = 1.0
    
    /// Color configuration for the pulse
    var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
    
    /// Initialize a new pulse component with default settings
    init(colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6)))) {
        self.colorConfig = colorConfig
    }
} 