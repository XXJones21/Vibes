# ``PulseConfiguration``

Configure particle effect appearance and behavior.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("Pulse Configuration")
}

## Overview

``PulseConfiguration`` defines the visual and behavioral characteristics of a particle effect. It provides a comprehensive set of parameters for customizing how particles look and move.

```swift
let config = PulseConfiguration(
    birthRate: 100,
    size: 0.03,
    lifetime: 3.0,
    speed: 0.1,
    emitterShape: .sphere,
    emitterSize: [0.5, 0.5, 0.5],
    acceleration: [0, 0.02, 0],
    color: .evolving(
        start: SIMD4(1, 0.9, 0.4, 1.0),
        end: SIMD4(1, 0.7, 0.2, 0.8)
    )
)
```

## Topics

### Essentials

- ``init(birthRate:size:lifetime:speed:emitterShape:emitterSize:acceleration:color:)``
- ``EmitterShape``
- ``PulseColor``

### Properties

- ``birthRate``
- ``size``
- ``lifetime``
- ``speed``
- ``emitterShape``
- ``emitterSize``
- ``acceleration``
- ``color``

### Color Configuration

- ``PulseColor/single(red:green:blue:alpha:)``
- ``PulseColor/evolving(start:end:)``
- ``PulseColor/realityKitColor``

### Emitter Shapes

- ``EmitterShape/sphere``
- ``EmitterShape/box``
- ``EmitterShape/point``

## Configuring Effects

Create a configuration for a specific effect type:

```swift
// Fireflies configuration
let firefliesConfig = PulseConfiguration(
    birthRate: 100,
    size: 0.03,
    lifetime: 3.0,
    speed: 0.1,
    emitterShape: .sphere,
    emitterSize: [0.5, 0.5, 0.5],
    acceleration: [0, 0.02, 0],
    color: .evolving(
        start: SIMD4(1, 0.9, 0.4, 1.0),
        end: SIMD4(1, 0.7, 0.2, 0.8)
    )
)

// Galaxy configuration
let galaxyConfig = PulseConfiguration(
    birthRate: 200,
    size: 0.02,
    lifetime: 3.0,
    speed: 0.2,
    emitterShape: .sphere,
    emitterSize: [0.8, 0.1, 0.8],
    acceleration: [0, -0.05, 0],
    color: .evolving(
        start: SIMD4(0.8, 0.9, 1.0, 1.0),
        end: SIMD4(0.9, 0.8, 1.0, 0.8)
    )
)
```

### Color Evolution

Colors can be static or evolve over time:

```swift
// Static color
let staticColor = PulseColor.single(
    red: 1.0,
    green: 0.9,
    blue: 0.4,
    alpha: 0.8
)

// Evolving color
let evolvingColor = PulseColor.evolving(
    start: SIMD4(1, 0.9, 0.4, 1.0),
    end: SIMD4(1, 0.7, 0.2, 0.8)
)
```

### Performance Considerations

When configuring effects:
- Use appropriate birth rates for the effect type
- Set reasonable lifetimes to manage particle count
- Choose emitter shapes that match the desired effect
- Consider performance impact of color evolution

## See Also

- ``PulseEffect``
- ``PulsePreset``
- ``FirefliesEffect``
- ``GalaxyEffect`` 