# ``PulseEffect``

Create stunning particle effects for immersive visionOS experiences.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("PulseEffect")
}

## Overview

The ``PulseEffect`` protocol defines the interface for creating particle effects in Vibes. Each effect manages its own properties and lifecycle, while integrating with the main particle system for efficient updates and resource management.

```swift
public protocol PulseEffect {
    var staticProperties: PulseStaticProperties { get }
    var dynamicProperties: PulseDynamicProperties { get set }
    var state: PulseEffectState { get }
    var isDirty: Bool { get set }
}
```

## Topics

### Essentials

- ``PulseEffectState``
- ``PulseStaticProperties``
- ``PulseDynamicProperties``

### Creating Effects

- ``FirefliesEffect``
- ``GalaxyEffect``
- ``DefaultPulseEffect``

### Properties

- ``staticProperties``
- ``dynamicProperties``
- ``state``
- ``isDirty``

### Property Management

- ``propertyDidChange(_:)``
- ``markDirty()``
- ``adjustEmissionVolume(scale:)``

### Effect Updates

- ``applyStaticProperties(_:)``
- ``updateDynamicProperties(_:deltaTime:)``

## Creating a Custom Effect

Create a custom effect by implementing the ``PulseEffect`` protocol:

```swift
class CustomEffect: PulseEffect {
    public private(set) var staticProperties: PulseStaticProperties
    public var dynamicProperties: PulseDynamicProperties
    public private(set) var state: PulseEffectState = .inactive
    public var isDirty: Bool = true
    
    init(preset: PulsePreset = .custom) {
        let configuration = preset.configuration
        self.staticProperties = PulseStaticProperties(configuration: configuration)
        self.dynamicProperties = PulseDynamicProperties(configuration: configuration)
    }
    
    public func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float) {
        // Update dynamic properties each frame
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = dynamicProperties.color.realityKitColor
    }
}
```

### Property Management

Effects use a property observer system to efficiently track changes:

```swift
extension PulseEffect {
    func propertyDidChange(_ keyPath: AnyKeyPath) {
        // Mark static properties as dirty if they change
        if keyPath == \PulseStaticProperties.emitterShape {
            markDirty()
        }
        
        // Update particle system for dynamic properties
        if var particleSystem = currentParticleSystem {
            updateDynamicProperties(&particleSystem, deltaTime: 0)
        }
    }
}
```

### Performance Optimization

Effects should follow these guidelines for optimal performance:

- Minimize property updates
- Cache calculated values
- Use efficient data structures
- Clean up resources properly

## See Also

- ``PulseParticles``
- ``PulseConfiguration``
- ``PulsePreset`` 