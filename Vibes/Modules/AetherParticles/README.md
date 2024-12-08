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
│   │   ├── NexusSystem.swift       # Large-scale immersive effects system
│   │   ├── NexusComponent.swift    # Component for complex particle behavior
│   │   ├── PulseSystem.swift       # Album visualization system
│   │   └── PulseComponent.swift    # Component for synchronized effects
│   ├── AetherParticles.swift       # Main API
│   ├── AetherParticlesView.swift   # SwiftUI integration
│   └── AetherParticleTypes.swift   # Shared types
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

## System Architecture

AetherParticles uses two specialized systems for different visualization needs:

1. **NexusSystem**: For large-scale, immersive effects
   - Complex particle physics and interactions
   - Used for welcome sequence and ambient effects
   - Handles scene-wide particle behaviors

2. **PulseSystem**: For album visualizations
   - Optimized for multiple small, synchronized effects
   - Perfect for album artwork enhancement
   - Efficient batch updates

## Usage

### System Registration

Register both systems at app launch:

```swift
if #available(visionOS 2.0, *) {
    // Register NexusSystem for large-scale immersive effects
    NexusSystem.registerSystem()
    // Register PulseSystem for album visualizations
    PulseSystem.registerSystem()
}
```

### Creating Effects

#### Large-Scale Effects

```swift
// Create a galaxy effect for immersive spaces
let galaxyEffect = AetherParticles(
    configuration: .galaxy,
    isLargeScale: true  // Uses NexusSystem
)

// Add to your RealityKit scene
myScene.addChild(galaxyEffect.rootEntity)

// Start emitting particles
galaxyEffect.start()
```

#### Album Visualizations

```swift
// Create a subtle effect for album artwork
let albumEffect = AetherParticles(
    configuration: .sparkles,
    isLargeScale: false  // Uses PulseSystem
)

// Add to your RealityKit scene
albumArtworkEntity.addChild(albumEffect.rootEntity)

// Start emitting particles
albumEffect.start()
```

### Using SwiftUI

```swift
// Large-scale ambient effect
AetherParticlesView(
    preset: .galaxy,
    isLargeScale: true
) { state in
    print("Effect state changed to: \(state)")
}

// Album artwork effect
AetherParticlesView(
    preset: .sparkles,
    isLargeScale: false
) { state in
    print("Album effect state: \(state)")
}
```

## Performance Guidelines

1. **System Choice**
   - Use NexusSystem for scene-wide effects
   - Use PulseSystem for localized effects
   - Don't mix systems unnecessarily

2. **Particle Counts**
   - NexusSystem: Up to 10,000 particles
   - PulseSystem: Up to 1,000 particles per emitter
   - Monitor performance with large particle counts

3. **Update Frequency**
   - Batch updates when possible
   - Use appropriate update intervals
   - Consider distance-based updates

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

## Known Issues

See [current-issues.md](../../current-issues.md) for current known issues and their status.

## Contributing

1. Follow the namespace convention (prefix with "Aether")
2. Use internal access level by default
3. Document all public APIs
4. Test on device when possible
5. Follow SwiftUI and RealityKit best practices
``` 