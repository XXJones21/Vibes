# VibesKit

VibesKit is a comprehensive package for creating immersive music visualizations in visionOS. It combines sophisticated particle systems with music analysis to create ethereal, responsive experiences.

## Modules

### AetherParticles

A specialized particle system for creating ethereal, music-reactive visualizations in visionOS.

```swift
import VibesKit

// Register the system when your app launches
AetherSystem.registerSystem()

// Create a particle effect
let particles = AetherParticles(configuration: .default)

// Or use a preset
let galaxyEffect = AetherParticles.withPreset(.galaxy)
```

Key features:
- Music-reactive particle behaviors
- Ethereal visual effects
- Preset configurations for different moods
- Support for complex animations
- Optimized for visionOS spatial experiences

### PulsarSymphony

A sophisticated music service that handles Apple Music integration with a focus on Dolby Atmos content.

```swift
import VibesKit

// Music functionality coming soon
```

## Requirements

- visionOS 1.0+
- Swift 6.0+

## Installation

Add VibesKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "path/to/VibesKit", from: "1.0.0")
]
```

## Usage

### Particle Effects

```swift
import VibesKit

// Initialize a particle system
let particles = AetherParticles(configuration: .default)

// Use presets for common effects
let fireflies = AetherParticles.withPreset(.fireflies)
let galaxy = AetherParticles.withPreset(.galaxy)

// Create custom configurations
let config = AetherParticles.ParticleConfiguration(
    emitterShape: .sphere,
    emitterSize: [1, 1, 1],
    birthRate: 100,
    colorConfig: .constant(.single(.white.withAlphaComponent(0.6))),
    bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
    acceleration: [0, 0, 0],
    speed: 0.2,
    lifetime: 3.0
)
```

### Welcome Animation

```swift
import VibesKit

let welcomeAnimation = WelcomeLetterAnimation(content: content) {
    print("Welcome animation complete")
}
```

## License

This package is part of the Vibes app and is not licensed for external use.