import RealityKit
import SwiftUI

/// AetherParticles is a specialized particle system for creating ethereal, music-reactive visualizations in visionOS.
/// 
/// This system provides a high-level interface for creating immersive particle effects that respond to music and create
/// atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.
///
/// Key features:
/// - Music-reactive particle behaviors
/// - Ethereal visual effects
/// - Preset configurations for different moods
/// - Support for complex animations like the welcome sequence
/// - Optimized for visionOS spatial experiences
@available(visionOS 2.0, *)
public class AetherParticles: ObservableObject {
    // MARK: - Properties
    
    /// Standard bounds for all particle systems
    public static let standardBounds = BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5])
    
    /// The root entity containing all particle components
    private(set) var _rootEntity: Entity
    
    /// The main particle emitter component
    private var emitterComponent: ParticleEmitterComponent
    
    /// The current configuration of the particle system
    private(set) var configuration: AetherConfiguration
    
    /// Whether this is a large-scale effect that needs NexusSystem
    private let isLargeScale: Bool
    
    /// The effects registry instance
    private let registry = EffectsRegistry.shared
    
    // MARK: - Types
    
    /// Represents the current state of the particle system
    public enum AetherState {
        /// System is not emitting particles
        case inactive
        /// System is actively emitting particles
        case active
        /// System is in the middle of a state change
        case transitioning
        /// System has finished its current sequence
        case complete
    }
    
    /// Available particle system presets
    public enum AetherPreset {
        case fireflies
        case sparkles
        case smoke
        case rain
        case galaxy
        case galaxySplit
        
        var configuration: AetherConfiguration {
            switch self {
            case .fireflies:
                let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.0,
                    green: 0.0,
                    blue: 1.0,
                    alpha: 0.8  // Keep some transparency for glow effect
                )
                
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [2, 2, 2],
                    birthRate: 500,
                    colorConfig: .constant(.single(blueColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.1,
                    lifetime: 2.0
                )
                
            case .galaxy:
                let redColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 0.0,
                    blue: 0.0,
                    alpha: 0.8
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [6, 6, 6],
                    birthRate: 150,
                    colorConfig: .constant(.single(redColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.1, -0.5],
                    speed: 0.3,
                    lifetime: 4.0
                )
                
            case .galaxySplit:
                let purpleColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.5,
                    green: 0.0,
                    blue: 0.5,
                    alpha: 0.9
                )
                let blueColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 0.0,
                    green: 0.0,
                    blue: 1.0,
                    alpha: 0.7
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1.5, 1.5, 1.5],
                    birthRate: 100,
                    colorConfig: .evolving(
                        start: .single(purpleColor),
                        end: .single(blueColor)
                    ),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.05, 0],
                    speed: 0.2,
                    lifetime: 3.0
                )
                
            case .sparkles:
                let whiteColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 1.0
                )
                return AetherConfiguration(
                    emitterShape: .point,
                    emitterSize: [0.1, 0.1, 0.1],
                    birthRate: 200,
                    colorConfig: .constant(.single(whiteColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, -0.5, 0],
                    speed: 0.5,
                    lifetime: 2.0
                )
                
            case .smoke:
                let startWhite = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.4
                )
                let endWhite = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.0
                )
                return AetherConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1, 1, 1],
                    birthRate: 50,
                    colorConfig: .evolving(
                        start: .single(startWhite),
                        end: .single(endWhite)
                    ),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, 0.2, 0],
                    speed: 0.1,
                    lifetime: 1.0
                )
                
            case .rain:
                let rainColor = ParticleEmitterComponent.ParticleEmitter.Color(
                    red: 1.0,
                    green: 1.0,
                    blue: 1.0,
                    alpha: 0.3
                )
                return AetherConfiguration(
                    emitterShape: .plane,
                    emitterSize: [10, 0.1, 10],
                    birthRate: 300,
                    colorConfig: .constant(.single(rainColor)),
                    bounds: BoundingBox(min: [-12.5, -12.5, -12.5], max: [12.5, 12.5, 12.5]),
                    acceleration: [0, -2.0, 0],
                    speed: 1.0,
                    lifetime: 1.0
                )
            }
        }
    }
    
    /// Configuration for the particle system
    public struct AetherConfiguration {
        /// The shape of the particle emitter (e.g., sphere, plane)
        var emitterShape: ParticleEmitterComponent.EmitterShape
        
        /// The size of the emitter shape in meters
        var emitterSize: SIMD3<Float>
        
        /// The rate at which new particles are created (particles per second)
        var birthRate: Float
        
        /// The color configuration for particles (constant, evolving, or random)
        var colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor
        
        /// The 3D bounds in which particles can exist
        var bounds: BoundingBox
        
        /// The acceleration applied to particles (in meters per second squared)
        var acceleration: SIMD3<Float>
        
        /// The initial speed of particle movement (in meters per second)
        var speed: Float
        
        /// The lifetime of each particle in seconds
        var lifetime: Float
        
        /// Creates a default configuration with moderate values
        public static var `default`: AetherConfiguration {
            AetherConfiguration(
                emitterShape: .sphere,
                emitterSize: [1, 1, 1],
                birthRate: 100,
                colorConfig: .constant(.single(.white.withAlphaComponent(0.6))),
                bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, 0, 0],
                speed: 0.2,
                lifetime: 3.0
            )
        }
        
        public init(
            emitterShape: ParticleEmitterComponent.EmitterShape = .sphere,
            emitterSize: SIMD3<Float> = [1, 1, 1],
            birthRate: Float = 100,
            colorConfig: ParticleEmitterComponent.ParticleEmitter.ParticleColor = .constant(.single(.white.withAlphaComponent(0.6))),
            bounds: BoundingBox = BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
            acceleration: SIMD3<Float> = [0, 0, 0],
            speed: Float = 0.2,
            lifetime: Float = 3.0
        ) {
            self.emitterShape = emitterShape
            self.emitterSize = emitterSize
            self.birthRate = birthRate
            self.colorConfig = colorConfig
            self.bounds = bounds
            self.acceleration = acceleration
            self.speed = speed
            self.lifetime = lifetime
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a new AetherParticles system with the specified configuration
    /// - Parameters:
    ///   - configuration: The configuration for the particle system
    ///   - isLargeScale: Whether this is a large-scale effect that needs NexusSystem (default: false)
    init(configuration: AetherConfiguration = .default, isLargeScale: Bool = false) {
        self.configuration = configuration
        self.isLargeScale = isLargeScale
        self._rootEntity = Entity()
        self.emitterComponent = ParticleEmitterComponent()
        
        setupEmitter()
    }
    
    /// Creates a new AetherParticles system with a registered effect
    /// - Parameters:
    ///   - effectType: The type of effect to create
    ///   - isLargeScale: Whether this is a large-scale effect
    convenience init?(effectType: EffectsRegistry.EffectType, isLargeScale: Bool = false) {
        let registry = EffectsRegistry.shared
        
        let key: String
        switch effectType {
        case .preset(let presetKey):
            key = presetKey
        case .visualizer(let visualizerKey):
            key = visualizerKey
        case .animation(let animationKey):
            key = animationKey
        }
        
        guard let config = registry.configuration(for: key) else {
            return nil
        }
        
        self.init(configuration: config, isLargeScale: isLargeScale)
        
        // Call lifecycle hook
        registry.willStart(key: key)
    }
    
    deinit {
        // Ensure we call didStop on the current effect
        if let currentKey = getCurrentEffectKey() {
            registry.didStop(key: currentKey)
        }
    }
    
    // MARK: - Methods
    
    /// Creates a particle system with a specific preset configuration
    static func withPreset(_ preset: AetherPreset, isLargeScale: Bool = false) -> AetherParticles {
        AetherParticles(configuration: preset.configuration, isLargeScale: isLargeScale)
    }
    
    /// Starts the particle system
    func start() {
        print("🎵 Particle System: Starting")
        print("🎵 Current State: \(state)")
        state = .active
        updateEmitter()
    }
    
    /// Stops the particle system and clears all particles
    func stop() {
        print("🎵 Particle System: Stopping")
        print("🎵 Final State: \(state)")
        state = .inactive
        updateEmitter()
    }
    
    /// Updates the configuration of the particle system
    func update(with configuration: AetherConfiguration) {
        print("🎵 Particle System: Updating")
        print("🎵 State Before Update: \(state)")
        self.configuration = configuration
        updateEmitter()
    }
    
    // MARK: - Private Methods
    
    private func setupEmitter() {
        // Create and configure the particle emitter
        var emitterComponent = ParticleEmitterComponent()
        
        // Configure emitter shape and size
        emitterComponent.emitterShape = configuration.emitterShape
        emitterComponent.emitterShapeSize = configuration.emitterSize
        
        // Configure particle appearance
        emitterComponent.mainEmitter.color = configuration.colorConfig
        emitterComponent.mainEmitter.birthRate = 0  // Always start with zero birth rate
        emitterComponent.mainEmitter.size = 0.1  // Larger size for better visibility
        emitterComponent.mainEmitter.lifeSpan = Double(configuration.lifetime)
        emitterComponent.mainEmitter.isLightingEnabled = false  // Disable lighting for glow
        
        // Explicitly enable emission
        emitterComponent.isEmitting = true
        
        // Configure movement
        emitterComponent.mainEmitter.acceleration = configuration.acceleration
        emitterComponent.speed = configuration.speed
        
        // Add to root entity
        _rootEntity.components.set(emitterComponent)
        
        // Add appropriate system component based on scale
        if isLargeScale {
            var nexusComponent = NexusComponent(
                colorConfig: configuration.colorConfig,
                physicsParams: .default
            )
            nexusComponent.intensity = 0.0  // Always start with zero intensity
            _rootEntity.components.set(nexusComponent)
        } else {
            var pulseComponent = PulseComponent(
                colorConfig: configuration.colorConfig
            )
            pulseComponent.intensity = 0.0  // Always start with zero intensity
            _rootEntity.components.set(pulseComponent)
        }
        
        // Position within bounds
        _rootEntity.position = [0, 0, 0]
        
        // Set initial state
        state = .inactive
    }
    
    private func updateEmitter() {
        // Update emitter component
        emitterComponent.mainEmitter.birthRate = state == .active ? configuration.birthRate : 0
        emitterComponent.mainEmitter.color = configuration.colorConfig
        emitterComponent.mainEmitter.acceleration = configuration.acceleration
        emitterComponent.speed = configuration.speed
        emitterComponent.isEmitting = true  // Ensure emission is enabled
        
        // Update on root entity
        _rootEntity.components.set(emitterComponent)
        
        // Direct intensity update on existing component
        if isLargeScale {
            if var component = _rootEntity.components[NexusComponent.self] {
                component.intensity = state == .active ? 1.0 : 0.0
                _rootEntity.components.set(component)
            }
        } else {
            if var component = _rootEntity.components[PulseComponent.self] {
                component.intensity = state == .active ? 1.0 : 0.0
                _rootEntity.components.set(component)
            }
        }
    }
    
    // Helper for rainbow colors
    static func randomRainbowColor() -> ParticleEmitterComponent.ParticleEmitter.ParticleColor {
        let hues: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        let randomHue = hues.randomElement() ?? 0
        let nextHue = hues.first(where: { $0 > randomHue }) ?? hues[0]
        
        // Convert hue to RGB for start color
        let (r1, g1, b1) = hueToRGB(hue: randomHue)
        let startColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: CGFloat(r1),
            green: CGFloat(g1),
            blue: CGFloat(b1),
            alpha: 0.8
        )
        
        // Convert hue to RGB for end color
        let (r2, g2, b2) = hueToRGB(hue: nextHue)
        let endColor = ParticleEmitterComponent.ParticleEmitter.Color(
            red: CGFloat(r2),
            green: CGFloat(g2),
            blue: CGFloat(b2),
            alpha: 0.6
        )
        
        return .evolving(
            start: .single(startColor),
            end: .single(endColor)
        )
    }

    // Convert hue to RGB (helper function)
    private static func hueToRGB(hue: CGFloat) -> (Float, Float, Float) {
        let h = hue * 6.0
        let i = floor(h)
        let f = h - i
        let p = 0.0
        let q = 1.0 - f
        let t = f
        
        switch Int(i) % 6 {
        case 0: return (1.0, Float(t), 0.0)
        case 1: return (Float(q), 1.0, 0.0)
        case 2: return (0.0, 1.0, Float(t))
        case 3: return (0.0, Float(q), 1.0)
        case 4: return (Float(t), 0.0, 1.0)
        case 5: return (1.0, 0.0, Float(q))
        default: return (0.0, 0.0, 0.0)
        }
    }
    
    private func getCurrentEffectKey() -> String? {
        // Implementation to track current effect key
        // This would need to be added to track which effect is currently active
        return nil
    }
}

// MARK: - Letter Animation Support

@available(visionOS 2.0, *)
extension AetherParticles {
    /// Predefined positions for the letters in "VIBES"
    static let letterPositions: [SIMD3<Float>] = [
        [-2.0, 0, 0],  // V
        [-1.0, 0, 0],  // I
        [0.0, 0, 0],   // B
        [1.0, 0, 0],   // E
        [2.0, 0, 0]    // S
    ]
    
    /// Creates a particle system configured for a specific letter position
    static func forLetterPosition(_ index: Int) -> AetherParticles {
        precondition(index >= 0 && index < letterPositions.count, "Letter index out of bounds")
        
        // Letter animations are large-scale effects
        let system = AetherParticles(configuration: AetherPreset.galaxySplit.configuration, isLargeScale: true)
        system._rootEntity.position = letterPositions[index]
        return system
    }
} 