# ``GalaxyEffect``

Create a swirling galaxy formation of particles.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("Galaxy Effect")
}

## Overview

The ``GalaxyEffect`` creates a mesmerizing spiral of particles that form a galaxy-like disk. It combines rotational motion with center attraction to create a dynamic, swirling effect.

```swift
let effect = GalaxyEffect(preset: .galaxy)
pulseParticles.addEffect(effect)
```

## Topics

### Essentials

- ``init(preset:)``
- ``spinForce``
- ``centerAttraction``

### Properties

- ``staticProperties``
- ``dynamicProperties``
- ``state``

### Customization

- ``updateDynamicProperties(_:deltaTime:)``
- ``adjustEmissionVolume(scale:)``

## Creating a Galaxy Effect

Create a galaxy effect with custom parameters:

```swift
// Create with default preset
let effect = GalaxyEffect()

// Create with custom preset
let customPreset = PulsePreset(
    name: "Custom Galaxy",
    configuration: PulseConfiguration(
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
    ),
    parameters: [
        "spinForce": 0.8,
        "centerAttraction": 0.3
    ]
)

let customEffect = GalaxyEffect(preset: customPreset)
```

### Spiral Motion

The galaxy effect creates its spiral motion through a combination of forces:

```swift
// Calculate spiral motion
let time = Float(currentTime)
let spiralX = cos(time * spinForce) * centerAttraction
let spiralZ = sin(time * spinForce) * centerAttraction

// Update acceleration for spiral motion
var acceleration = dynamicProperties.acceleration
acceleration.x = spiralX
acceleration.z = spiralZ
```

### Performance Notes

The galaxy effect is optimized for performance:
- Uses efficient spiral calculations
- Minimizes trigonometric operations
- Implements proper cleanup
- Caches calculated values

## See Also

- ``PulseEffect``
- ``FirefliesEffect``
- ``PulsePreset`` 