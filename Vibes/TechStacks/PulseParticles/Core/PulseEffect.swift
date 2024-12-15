import RealityKit
import Foundation

/// Defines the shape of the particle emitter
@available(visionOS 2.0, *)
public typealias EmitterShape = PulseConfiguration.EmitterShape

/// Color configuration for pulse effects
@available(visionOS 2.0, *)
public typealias PulseColor = PulseConfiguration.PulseColor

/// Static properties that rarely change during effect lifetime
@available(visionOS 2.0, *)
public struct PulseStaticProperties {
    let emitterShape: EmitterShape
    let emitterSize: SIMD3<Float>
    let speed: Float
    let lifetime: Float
    
    init(configuration: PulseConfiguration) {
        self.emitterShape = configuration.emitterShape
        self.emitterSize = configuration.emitterSize
        self.speed = configuration.speed
        self.lifetime = configuration.lifetime
    }
}

/// Dynamic properties that change frequently during effect lifetime
@available(visionOS 2.0, *)
public struct PulseDynamicProperties {
    var birthRate: Float
    var color: PulseColor
    var acceleration: SIMD3<Float>
    
    init(configuration: PulseConfiguration) {
        self.birthRate = configuration.birthRate
        self.color = configuration.color
        self.acceleration = configuration.acceleration
    }
}

/// Property observer for tracking changes
@available(visionOS 2.0, *)
public protocol PropertyObserver: AnyObject {
    func propertyDidChange(_ keyPath: AnyKeyPath)
}

/// Property wrapper for observable properties
@available(visionOS 2.0, *)
@propertyWrapper
public struct Observable<T> {
    private var value: T
    private weak var observer: PropertyObserver?
    private let keyPath: AnyKeyPath
    
    public init(wrappedValue: T, observer: PropertyObserver? = nil, keyPath: AnyKeyPath) {
        self.value = wrappedValue
        self.observer = observer
        self.keyPath = keyPath
    }
    
    public var wrappedValue: T {
        get { value }
        set {
            value = newValue
            observer?.propertyDidChange(keyPath)
        }
    }
}

/// A protocol defining the interface for all pulse particle effects.
///
/// PulseEffect provides a standardized way to create and manage particle effects in the Vibes app.
/// Each effect manages its own static and dynamic properties, and can be updated on a per-frame basis.
///
/// ## Overview
///
/// A pulse effect consists of:
/// - Static properties that rarely change (shape, size, lifetime)
/// - Dynamic properties that update frequently (color, birth rate, acceleration)
/// - A state machine for managing effect lifecycle
/// - Property observation for efficient updates
///
/// ## Topics
///
/// ### Creating Effects
/// - ``init(preset:)``
/// - ``PulsePreset``
///
/// ### Properties
/// - ``staticProperties``
/// - ``dynamicProperties``
/// - ``state``
/// - ``isDirty``
///
/// ### Updating Effects
/// - ``updateDynamicProperties(_:deltaTime:)``
/// - ``applyStaticProperties(_:)``
/// - ``markDirty()``
///
/// ### Example
///
/// ```swift
/// let effect = FirefliesEffect(preset: .fireflies)
/// pulseParticles.addEffect(effect)
/// pulseParticles.scaleEffect(effect, to: 2.0)
/// ```
@available(visionOS 2.0, *)
public protocol PulseEffect: PropertyObserver {
    /// Static properties that rarely change
    var staticProperties: PulseStaticProperties { get }
    
    /// Dynamic properties that change frequently
    var dynamicProperties: PulseDynamicProperties { get set }
    
    /// The current state of the effect
    var state: PulseEffectState { get }
    
    /// Track if static properties need update
    var isDirty: Bool { get set }
    
    /// Reference to current particle system
    var currentParticleSystem: ParticleEmitterComponent? { get set }
    
    /// Apply static properties to a particle system
    /// - Parameter particleSystem: The particle system to update
    func applyStaticProperties(_ particleSystem: inout ParticleEmitterComponent)
    
    /// Update dynamic properties for the current frame
    /// - Parameters:
    ///   - particleSystem: The particle system to update
    ///   - deltaTime: Time since last update in seconds
    func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float)
    
    /// Mark effect as needing static property update
    func markDirty()
    
    /// Called when a property changes
    /// - Parameter keyPath: The key path of the changed property
    func propertyDidChange(_ keyPath: AnyKeyPath)
    
    /// Adjust emission volume based on scale
    /// - Parameter scale: The scale factor to apply
    func adjustEmissionVolume(scale: Float)
}

/// Default implementations
@available(visionOS 2.0, *)
public extension PulseEffect {
    func propertyDidChange(_ keyPath: AnyKeyPath) {
        // Mark static properties as dirty if they change
        if keyPath == \PulseStaticProperties.emitterShape ||
           keyPath == \PulseStaticProperties.emitterSize ||
           keyPath == \PulseStaticProperties.speed ||
           keyPath == \PulseStaticProperties.lifetime {
            markDirty()
        }
        
        // Update particle system immediately for dynamic properties
        if var particleSystem = currentParticleSystem {
            updateDynamicProperties(&particleSystem, deltaTime: 0)
            currentParticleSystem = particleSystem
        }
    }
    
    func markDirty() {
        isDirty = true
        if var particleSystem = currentParticleSystem {
            applyStaticProperties(&particleSystem)
            currentParticleSystem = particleSystem
        }
    }
    
    func applyStaticProperties(_ particleSystem: inout ParticleEmitterComponent) {
        particleSystem.emitterShape = staticProperties.emitterShape.realityKitShape
        particleSystem.emitterShapeSize = staticProperties.emitterSize
        particleSystem.speed = staticProperties.speed
        particleSystem.mainEmitter.lifeSpan = Double(staticProperties.lifetime)
        isDirty = false
    }
    
    func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float) {
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = dynamicProperties.color.realityKitColor
        particleSystem.mainEmitter.acceleration = .init(dynamicProperties.acceleration)
    }
    
    func adjustEmissionVolume(scale: Float) {
        // Scale birth rate and emitter size with overall scale
        var particleSystem = currentParticleSystem
        particleSystem?.mainEmitter.birthRate *= scale
        particleSystem?.emitterShapeSize *= scale
        currentParticleSystem = particleSystem
    }
}

/// Represents the current state of a pulse effect
@available(visionOS 2.0, *)
public enum PulseEffectState {
    /// Effect is not active
    case inactive
    /// Effect is actively emitting particles
    case active
    /// Effect is transitioning between states
    case transitioning(progress: Float)
    /// Effect has completed its sequence
    case completed
    
    /// Whether the effect is currently emitting particles
    var isEmitting: Bool {
        switch self {
        case .active, .transitioning: return true
        case .inactive, .completed: return false
        }
    }
} 