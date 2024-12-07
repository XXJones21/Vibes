import PulsarSymphony
import AetherParticles

/// Main interface for VibesKit
public enum VibesKit {
    // Re-exports from PulsarSymphony
    public typealias MusicController = PulsarSymphony.PlaybackController
    public typealias AudioState = PulsarSymphony.PlaybackState
    
    // Re-exports from AetherParticles
    public typealias ParticleSystem = AetherParticles.ParticleSystem
    public typealias Emitter = AetherParticles.ParticleEmitter
    
    /// Version of the VibesKit package
    public static let version = "1.0.0"
} 