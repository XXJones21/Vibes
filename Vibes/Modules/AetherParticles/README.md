# AetherParticles

A specialized particle system module for creating ethereal, music-reactive visualizations in visionOS.

## Overview

AetherParticles provides a high-level interface for creating immersive particle effects that respond to music and create atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.

## Features

- Music-reactive particle behaviors
- Ethereal visual effects
- Preset configurations for different moods
- Support for complex animations
- Optimized for visionOS spatial experiences

## Module Structure

```
AetherParticles/
├── Core/
│   ├── System/
│   │   └── AetherSystem.swift       # RealityKit System implementation
│   ├── AetherParticles.swift        # Main API
│   ├── AetherParticlesView.swift    # SwiftUI integration
│   └── AetherParticleTypes.swift    # Shared types
└── Effects/
    ├── AetherPresets/
    │   ├── AetherFirefliesEffect.swift     # Floating, glowing particles
    │   ├── AetherGalaxyEffect.swift        # Swirling galaxy formation
    │   ├── AetherGalaxySplitEffect.swift   # Split galaxy swirls
    │   ├── AetherRainEffect.swift          # Gentle rain particles
    │   ├── AetherSmokeEffect.swift         # Ethereal smoke formations
    │   └── AetherSparklesEffect.swift      # Bright, twinkling sparkles
    └── AetherAnimations/
        └── AetherWelcomeAnimation.swift    # Welcome sequence animation
```

## Usage

### Basic Setup

```swift
import RealityKit

// Create a particle system with default configuration
let particles = AetherParticles()

// Add to your RealityKit scene
myScene.addChild(particles.rootEntity)

// Start emitting particles
particles.start()
```

### Using Presets

```swift
// Create a particle system with a preset
let galaxyParticles = AetherParticles.withPreset(.galaxy)
let fireflies = AetherParticles.withPreset(.fireflies)

// Custom configuration
let config = AetherConfiguration(
    emitterShape: .sphere,
    emitterSize: [2, 2, 2],
    birthRate: 100,
    colorConfig: .constant(.single(.white)),
    bounds: AetherParticles.standardBounds,
    acceleration: [0, 0.05, 0],
    speed: 0.1,
    lifetime: 2.0
)

particles.update(with: config)
```

### Welcome Animation

```swift
// Create the welcome animation
let welcomeAnimation = AetherWelcomeAnimation(content: myRealityView) {
    print("Animation complete!")
}

// Add to your scene
myScene.addChild(welcomeAnimation.entity)

// Start the animation sequence
welcomeAnimation.start()
```

## Requirements

- visionOS 2.0+
- RealityKit
- SwiftUI

## Best Practices

1. **Memory Management**
   - Stop particle systems when not in view
   - Use appropriate particle counts
   - Monitor memory usage with large particle counts

2. **Performance**
   - Use standardized bounds (±12.5 units)
   - Batch particle updates when possible
   - Consider entity pooling for complex effects

3. **Animation Timing**
   - Follow UX specifications for durations
   - Use smooth transitions between phases
   - Test performance with different particle counts

## Known Issues

See [current-issues.md](../../current-issues.md) for current known issues and their status.

## Contributing

1. Follow the namespace convention (prefix with "Aether")
2. Use internal access level by default
3. Document all public APIs
4. Test on device when possible
5. Follow SwiftUI and RealityKit best practices
``` 