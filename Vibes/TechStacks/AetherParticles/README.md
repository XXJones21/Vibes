# AetherParticles

A specialized particle system module for creating ethereal, music-reactive visualizations in visionOS.

## Overview

AetherParticles provides a high-level interface for creating immersive particle effects that respond to music and create atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.

## Features

- Music-reactive particle behaviors
- Component-based architecture for better lifecycle management
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
│   │   ├── NexusComponent.swift    # Component for large-scale effects
│   │   └── PulseComponent.swift    # Component for album visualizations
│   ├── AetherPhysics.swift         # Shared physics calculations
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

## Component Architecture

AetherParticles uses a component-based architecture for better lifecycle management and performance:

1. **NexusComponent**: For large-scale, immersive effects
   - Complex particle physics and interactions
   - Used for welcome sequence and ambient effects
   - Handles scene-wide particle behaviors
   - Supports up to 10,000 particles
   - Automatic lifecycle management

2. **PulseComponent**: For album visualizations
   - Optimized for multiple small, synchronized effects
   - Perfect for album artwork enhancement
   - Efficient batch updates
   - Up to 1,000 particles per emitter
   - Proper cleanup on removal

3. **AetherPhysics**: Shared physics engine
   - Wave effects for oscillating motion
   - Swirl effects for circular patterns
   - Attraction effects for gravitational behavior
   - Spiral effects for galaxy formations
   - Used by both components

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
    preset: .galaxy,
    isLargeScale: true  // Uses NexusComponent
)

// Add to your RealityKit scene
myScene.addChild(galaxyEffect.rootEntity)
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

1. **Component Choice**
   - Use NexusComponent for scene-wide effects
   - Use PulseComponent for localized effects
   - Share physics calculations through AetherPhysics

2. **Particle Counts**
   - NexusComponent: Up to 10,000 particles
   - PulseComponent: Up to 1,000 particles per emitter
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

1. **Component Lifecycle**
   - Components are automatically registered and unregistered
   - Proper cleanup happens on component removal
   - Monitor component state changes

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

## Documentation

Full DocC documentation coming soon. This will include:
- Detailed component lifecycle management
- Performance optimization guides
- Physics implementation details
- Best practices for custom effects
``` 