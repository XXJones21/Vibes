# PulseParticles

A modern, flexible particle system for visionOS that supports multiple simultaneous effects with automatic performance optimization.

## Overview

PulseParticles is designed to create immersive particle effects in visionOS applications. It features:
- Multiple simultaneous effects with automatic layout
- Built-in performance monitoring and optimization
- Protocol-based effect system for easy extensibility
- Spatial management for effect positioning
- Automatic resource cleanup

## Architecture

### Core Components

```
PulseParticles/
├── Core/
│   ├── PulseParticles.swift       # Main system manager
│   ├── PulseEffect.swift          # Effect protocol and property management
│   ├── PulseConfiguration.swift   # Effect configuration
│   └── PulsePreset.swift         # Preset configurations
├── Effects/
│   ├── FirefliesEffect.swift      # Floating, glowing particles
│   └── GalaxyEffect.swift         # Swirling galaxy formation
└── Views/
    └── PulseSystemView.swift      # SwiftUI integration
```

### Key Classes and Protocols

#### `PulseParticles`
The main system manager that handles:
- Effect lifecycle management
- Performance monitoring
- Spatial positioning
- Resource management
- Component reuse and caching

```swift
let pulseSystem = PulseParticles(maxEffects: 5)
pulseSystem.addEffect(FirefliesEffect())
```

#### `PulseEffect` Protocol
Defines the interface for all particle effects with optimized property management:
```swift
public protocol PulseEffect {
    // Static properties (rarely change)
    var staticProperties: PulseStaticProperties { get }
    
    // Dynamic properties (update frequently)
    var dynamicProperties: PulseDynamicProperties { get set }
    
    // Property change observation
    func propertyDidChange(_ keyPath: AnyKeyPath)
}
```

#### Property Management
The system uses an efficient property management system:
```swift
// Static properties (updated only when needed)
public struct PulseStaticProperties {
    let emitterShape: EmitterShape
    let emitterSize: SIMD3<Float>
    let speed: Float
    let lifetime: Float
}

// Dynamic properties (updated frequently)
public struct PulseDynamicProperties {
    var birthRate: Float
    var color: PulseColor
    var acceleration: SIMD3<Float>
}

// Property observation
@Observable(keyPath: \.birthRate)
var birthRate: Float
```

#### `PulseConfiguration`
Configures effect appearance and behavior:
- Birth rate and lifetime
- Size and shape
- Motion parameters
- Color configuration

#### `PulseSystemView`
SwiftUI view for displaying effects:
```swift
PulseSystemView(effects: [
    FirefliesEffect(),
    GalaxyEffect()
])
```

## Built-in Effects

### FirefliesEffect
Creates gentle, floating particles with pulsing glow:
- Smooth motion with slight randomness
- Configurable glow intensity
- Color transitions
- Adjustable density

### GalaxyEffect
Creates a swirling galaxy formation:
- Spiral motion with center attraction
- Configurable spin force
- Color evolution
- Adjustable size and density

## Performance Management

The system automatically manages performance through several mechanisms:

### Batched Updates
```swift
// Updates are processed in efficient batches
private class BatchUpdateManager {
    private let batchSize: Int = 10
    private let updateInterval: TimeInterval = 1.0 / 60.0
    
    func addUpdate(_ particleSystem: ParticleEmitterComponent, update: @escaping () -> Void)
    func processBatch(currentTime: TimeInterval)
}
```

### Performance Monitoring
```swift
// Get detailed performance metrics
let metrics = pulseSystem.detailedMetrics
print("Active Effects: \(metrics.activeEffects)")
print("Average FPS: \(metrics.averageFrameRate)")
print("Average Update Time: \(metrics.averageUpdateTime)ms")
print("Peak Update Time: \(metrics.peakUpdateTime)ms")
```

### Automatic Optimization
- Batched property updates (10 updates per frame)
- 60fps target update rate
- Automatic effect reduction when FPS drops
- Memory-efficient component reuse
- Performance history tracking

## Spatial Management

Effects are automatically positioned in 3D space:
- Circular arrangement by default
- Minimum distance enforcement
- Automatic repositioning
- Custom positioning support

```swift
// Custom position for an effect
pulseSystem.setPosition(for: effect, position: [1, 0, 1])
```

## Creating Custom Effects

1. Create a new effect class:
```swift
class CustomEffect: PulseEffect {
    public private(set) var state: PulseEffectState = .inactive
    public private(set) var staticProperties: PulseStaticProperties
    public var dynamicProperties: PulseDynamicProperties
    public var isDirty: Bool = true
    public var currentParticleSystem: ParticleEmitterComponent?
    
    init(preset: PulsePreset) {
        let configuration = preset.configuration
        self.staticProperties = PulseStaticProperties(configuration: configuration)
        self.dynamicProperties = PulseDynamicProperties(configuration: configuration)
    }
    
    public func updateDynamicProperties(_ particleSystem: ParticleEmitterComponent, deltaTime: Float) {
        // Update dynamic properties each frame
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = dynamicProperties.color.realityKitColor
        particleSystem.mainEmitter.acceleration = .init(dynamicProperties.acceleration)
    }
}
```

2. Configure effect behavior through presets:
```swift
extension PulsePreset {
    static var custom: PulsePreset {
        PulsePreset(
            name: "Custom",
            description: "Custom effect description",
            configuration: PulseConfiguration(
                birthRate: 100,
                size: 0.05,
                lifetime: 2.0,
                speed: 0.5,
                emitterShape: .sphere,
                emitterSize: [1, 1, 1],
                acceleration: [0, 0.1, 0],
                color: .single(red: 1, green: 1, blue: 1, alpha: 0.6)
            )
        )
    }
}
```

3. Add to the system:
```swift
let effect = CustomEffect(preset: .custom)
pulseSystem.addEffect(effect)
```

## Best Practices

1. **Effect Management**
   - Keep effects focused and single-purpose
   - Clean up resources when effects complete
   - Use presets for common configurations

2. **Performance**
   - Monitor performance metrics
   - Set appropriate max effects limit
   - Use efficient particle counts

3. **Spatial Layout**
   - Consider effect visibility
   - Maintain appropriate spacing
   - Update positions smoothly

4. **Resource Usage**
   - Clean up completed effects
   - Limit particle counts
   - Use appropriate lifetimes

## Integration Example

```swift
struct ContentView: View {
    var body: some View {
        PulseSystemView(effects: [
            FirefliesEffect(preset: .fireflies),
            GalaxyEffect(preset: .galaxy)
        ], maxEffects: 5)
        .onAppear {
            // Additional setup if needed
        }
    }
}
```

## Troubleshooting

1. **Low Frame Rate**
   - Reduce maximum effects
   - Lower particle birth rates
   - Decrease particle lifetimes

2. **Visual Issues**
   - Check effect configurations
   - Verify spatial positioning
   - Ensure proper cleanup

3. **Memory Usage**
   - Monitor active effect count
   - Clean up completed effects
   - Use appropriate particle counts

## Contributing

1. Follow the protocol-based design
2. Add tests for new effects
3. Document configurations
4. Consider performance impact

## License

MIT License - See LICENSE file for details 