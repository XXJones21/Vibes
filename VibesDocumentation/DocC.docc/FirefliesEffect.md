# ``FirefliesEffect``

Create gentle, floating particles that glow and drift through space.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("Fireflies Effect")
}

## Overview

The ``FirefliesEffect`` creates a mesmerizing display of glowing particles that float and pulse in 3D space. It's perfect for creating ambient backgrounds or highlighting spatial areas.

```swift
let effect = FirefliesEffect(preset: .fireflies)
pulseParticles.addEffect(effect)
```

## Topics

### Essentials

- ``init(preset:)``
- ``pulseFrequency``
- ``pulseAmplitude``

### Properties

- ``staticProperties``
- ``dynamicProperties``
- ``state``

### Customization

- ``updateDynamicProperties(_:deltaTime:)``
- ``adjustEmissionVolume(scale:)``

## Creating a Fireflies Effect

Create a fireflies effect with custom parameters:

```swift
// Create with default preset
let effect = FirefliesEffect()

// Create with custom preset
let customPreset = PulsePreset(
    name: "Custom Fireflies",
    configuration: PulseConfiguration(
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
    ),
    parameters: [
        "pulseFrequency": 2.0,
        "pulseAmplitude": 0.5
    ]
)

let customEffect = FirefliesEffect(preset: customPreset)
```

### Glow Effect

The fireflies effect includes a pulsing glow that creates a more dynamic appearance:

```swift
// Calculate glow effect
let glowIntensity = 0.8 + sin(Float(currentTime) * pulseFrequency) * pulseAmplitude

// Update color with glow
let color = dynamicProperties.color
color.alpha *= glowIntensity
```

### Performance Notes

The fireflies effect is optimized for performance:
- Uses efficient property updates
- Minimizes particle count
- Implements proper cleanup

## See Also

- ``PulseEffect``
- ``GalaxyEffect``
- ``PulsePreset`` 