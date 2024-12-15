# ``PulsePreset``

Predefined configurations for particle effects.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("Pulse Preset")
}

## Overview

``PulsePreset`` provides ready-to-use configurations for particle effects. Each preset includes a base configuration and additional parameters specific to the effect type.

```swift
// Use a standard preset
let effect = FirefliesEffect(preset: .fireflies)

// Get a parameter from a preset
let pulseFrequency = preset.parameter("pulseFrequency", defaultValue: 0.5)
```

## Topics

### Essentials

- ``init(name:description:configuration:parameters:)``
- ``name``
- ``description``
- ``configuration``
- ``parameters``

### Parameter Access

- ``parameter(_:defaultValue:)``

### Standard Presets

- ``fireflies``
- ``galaxy``

## Creating Custom Presets

Create a custom preset for your effect:

```swift
let customPreset = PulsePreset(
    name: "Custom Fireflies",
    description: "Gentle, floating particles with custom glow",
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
```

### Standard Presets

The system includes optimized presets:

```swift
extension PulsePreset {
    /// Gentle, floating particles
    static var fireflies: PulsePreset {
        PulsePreset(
            name: "Fireflies",
            description: "Gentle, floating particles that drift through space",
            configuration: PulseConfiguration(/* ... */),
            parameters: [
                "pulseFrequency": 2.0,
                "pulseAmplitude": 0.5
            ]
        )
    }
    
    /// Swirling galaxy formation
    static var galaxy: PulsePreset {
        PulsePreset(
            name: "Galaxy",
            description: "Swirling particles forming a galaxy-like disk",
            configuration: PulseConfiguration(/* ... */),
            parameters: [
                "spinForce": 0.8,
                "centerAttraction": 0.3
            ]
        )
    }
}
```

### Parameter Management

Access preset parameters safely:

```swift
// Get parameter with default value
let frequency = preset.parameter("pulseFrequency", defaultValue: 0.5)

// Check if parameter exists
if let amplitude = preset.parameters["pulseAmplitude"] {
    print("Amplitude: \(amplitude)")
}
```

## Performance Guidelines

When creating presets:
- Use reasonable default values
- Consider performance impact
- Document parameter ranges
- Provide sensible defaults

## See Also

- ``PulseConfiguration``
- ``PulseEffect``
- ``FirefliesEffect``
- ``GalaxyEffect`` 