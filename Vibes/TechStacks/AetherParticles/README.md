# AetherParticles

A specialized particle system module for creating ethereal, music-reactive visualizations in visionOS.

## Overview

AetherParticles provides a high-level interface for creating immersive particle effects that respond to music and create atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.

## Features

- Music-reactive particle behaviors
- Physically accurate effects (galaxy formations, fluid dynamics)
- Shared physics engine for consistent behaviors
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
│   │   ├── PulseComponent.swift    # Component for synchronized effects
│   │   └── AetherPhysics.swift     # Shared physics calculations
│   ├── AetherParticles.swift       # Main API
│   ├── AetherParticlesView.swift   # SwiftUI integration
│   └── AetherParticleTypes.swift   # Shared types
└── Effects/
    ├── AetherPresets/
    │   ├── AetherFirefliesEffect.swift     # Floating, glowing particles
    │   ├── AetherGalaxyEffect.swift        # Physically accurate galaxy formation
    │   ├── AetherGalaxySplitEffect.swift   # Split galaxy swirls
    │   ├── AetherRainEffect.swift          # Gentle rain particles
    │   ├── AetherSmokeEffect.swift         # Ethereal smoke formations
    │   └── AetherSparklesEffect.swift      # Bright, twinkling sparkles
    └── AetherAnimations/
        └── AetherWelcomeAnimation.swift    # Welcome sequence animation
```

## System Architecture

AetherParticles uses three main components for different visualization needs:

1. **NexusSystem**: For large-scale, immersive effects
   - Complex particle physics and interactions
   - Used for welcome sequence and ambient effects
   - Handles scene-wide particle behaviors
   - Supports up to 10,000 particles

2. **PulseSystem**: For album visualizations
   - Optimized for multiple small, synchronized effects
   - Perfect for album artwork enhancement
   - Efficient batch updates
   - Up to 1,000 particles per emitter

3. **AetherPhysics**: Shared physics engine
   - Wave effects for oscillating motion
   - Swirl effects for circular patterns
   - Attraction effects for gravitational behavior
   - Spiral effects for galaxy formations
   - Used by both Nexus and Pulse systems

## Physics Implementation

The module includes physically accurate simulations:

1. **Galaxy Formation**
   - Simulates black hole gravitational influence
   - Includes dark matter halo effects
   - Models spiral arm perturbations
   - Uses real astronomical constants (scaled)

2. **Particle Dynamics**
   - Wave-based motion patterns
   - Gravitational attractions
   - Fluid-like behaviors
   - Customizable physics parameters

### Physics Function Guidelines

Functions should be added to AetherPhysics when they:
1. Implement fundamental physical behaviors (gravity, waves, spirals)
2. Are reusable across multiple presets
3. Require complex mathematical calculations
4. Need to maintain consistency across the app

Functions should stay in presets when they:
1. Are specific to a single visual effect
2. Implement artistic rather than physical behaviors
3. Are tightly coupled with music reactivity
4. Serve as variations of existing AetherPhysics functions

## Usage

### Creating Effects

```swift
// Create a physically accurate galaxy effect
let galaxyEffect = AetherParticles(
    configuration: .galaxy,
    isLargeScale: true  // Uses NexusSystem
)

// Add to your RealityKit scene
myScene.addChild(galaxyEffect.rootEntity)

// Start emitting particles
galaxyEffect.start()
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
```

## Performance Guidelines

1. **System Choice**
   - Use NexusSystem for scene-wide effects
   - Use PulseSystem for localized effects
   - Share physics calculations through AetherPhysics

2. **Particle Counts**
   - NexusSystem: Up to 10,000 particles
   - PulseSystem: Up to 1,000 particles per emitter
   - Monitor performance with large particle counts

3. **Physics Optimization**
   - Use appropriate update intervals
   - Share calculations via AetherPhysics
   - Batch physics updates when possible

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

3. **Physics Usage**
   - Use shared AetherPhysics for consistent behavior
   - Combine basic effects for complex motion
   - Consider physical accuracy vs. performance

## Known Issues

See [current-issues.md](../../current-issues.md) for current known issues and their status.

## Contributing

1. Follow the namespace convention (prefix with "Aether")
2. Use internal access level by default
3. Document all public APIs
4. Test on device when possible
5. Follow SwiftUI and RealityKit best practices
``` 