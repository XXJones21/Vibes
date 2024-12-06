# VibesParticles

A RealityKit-based ethereal particle system package for visionOS, providing immersive, music-reactive visual effects and animations. Built exclusively using RealityKit's native ParticleEmitterComponent for optimal performance and system integration.

## Overview

AetherParticles is a specialized particle system designed to create visual connections between users and their music in visionOS. It provides ethereal, atmospheric effects that can react to music and create immersive spatial experiences.

## Golden Rules
- Always use RealityKit's ParticleEmitterComponent.ParticleEmitter.Color for particle colors
- Never use SwiftUI or UIKit colors in particle systems
- Maintain proper visionOS 2.0+ availability attributes
- Follow RealityKit's particle system best practices for performance
- Consider music reactivity in effect design
- Set particle lifetime on the mainEmitter, not the component itself
- Always set a reasonable particle lifetime (1-5 seconds) to prevent accumulation
- Consider particle count and performance impact in your design

## Best Practices

### Performance
- Keep particle count minimal - use the minimum needed for the desired effect
- Use efficient emitter shapes that match your effect's needs
- Implement proper particle pooling and reuse
- Consider using birth rate modulation instead of creating new systems
- Clean up particles when they're no longer needed
- Monitor frame rate impact with different particle counts
- Use appropriate particle lifetimes to manage system load
- Consider using simpler particle shapes for better performance

### Visual Quality
- Match particle size to the scale of your scene
- Use appropriate alpha values for depth perception
- Consider particle lifetime for natural effects
- Implement smooth color transitions
- Use appropriate emitter shapes for different effects:
  - Sphere: For ambient effects like fireflies (good for 360° dispersion)
  - Point: For focused effects like sparkles (efficient for concentrated effects)
  - Plane: For environmental effects like rain (ideal for directional effects)
- Consider particle size variation for more natural effects
- Use color evolution for dynamic visual interest
- Implement proper depth sorting with alpha blending

### System Design
- Organize particle systems hierarchically
- Use bounds to contain particles within desired areas
- Implement proper state management (active, inactive, transitioning)
- Handle cleanup and memory management explicitly
- Consider spatial audio integration for immersion
- Design for modularity and reusability
- Implement proper error handling and state validation
- Use configuration presets for common effects

### RealityKit Integration
- Properly integrate with RealityView for SwiftUI apps
- Handle entity lifecycle management
- Use RealityKit's built-in physics when applicable
- Consider spatial interaction with other entities
- Implement proper scene graph management
- Handle system state changes appropriately
- Use RealityKit's native types for better performance
- Consider view space vs world space for particle effects

### Example Implementations

#### Efficient Particle Configuration

```swift
// Configure particles with performance in mind
let config = AetherParticles.ParticleConfiguration(
    emitterShape: .sphere,
    emitterSize: [2, 2, 2],
    birthRate: 100,  // Keep birth rate reasonable
    colorConfig: .evolving(
        start: .single(startColor),
        end: .single(endColor)
    ),
    bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),  // Contain particles
    acceleration: [0, 0.1, 0],
    speed: 0.5,
    lifetime: 3.0  // Important: Set appropriate lifetime
)
```

#### Birth Rate Modulation

```swift
// Instead of creating new systems, modulate birth rate
func updateIntensity(intensity: Float) {
    let newBirthRate = baseRate * intensity
    emitterComponent.mainEmitter.birthRate = min(newBirthRate, maxBirthRate)
}
```

#### Proper Cleanup

```swift
// Implement proper cleanup
func cleanup() {
    // Stop emission first
    emitterComponent.mainEmitter.birthRate = 0
    
    // Allow existing particles to fade out
    DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) { [weak self] in
        self?.rootEntity.removeFromParent()
    }
}
```

#### Distance-Based Culling

```swift
// Implement distance-based culling
func updateVisibility(viewerPosition: SIMD3<Float>) {
    let distance = length(viewerPosition - rootEntity.position)
    let isVisible = distance <= visibilityThreshold
    
    if isVisible != isCurrentlyVisible {
        emitterComponent.mainEmitter.birthRate = isVisible ? normalBirthRate : 0
        isCurrentlyVisible = isVisible
    }
}
```

## Features

- Native RealityKit particle systems
- Music-reactive particle behaviors
- Ethereal visual effects
- Preset animations (fireflies, galaxy, sparkles)
- RealityKit color evolution and transitions
- Spatial awareness and bounds management
- Performance-optimized using RealityKit's particle pooling
- Dynamic birth rate modulation
- Proper particle lifetime management
- Efficient cleanup and memory handling

## Performance Guidelines

### Particle Count Recommendations
- Ambient effects: 100-200 particles
- Focused effects: 50-100 particles
- Complex effects: Up to 500 particles (monitor performance)
- System-wide limit: Consider keeping total particles under 1000

### Frame Rate Targets
- Maintain 60 FPS minimum
- Monitor CPU/GPU impact
- Use particle culling when appropriate
- Implement LOD (Level of Detail) for distant effects

### Memory Management
- Implement proper cleanup
- Use particle pooling
- Monitor memory usage
- Cache commonly used resources
- Clean up unused systems promptly

## Common Pitfalls to Avoid
- Not setting particle lifetime
- Excessive particle counts
- Memory leaks from uncleaned systems
- Poor performance from complex particle shapes
- Inefficient update loops
- Missing cleanup in lifecycle events
- Improper RealityKit integration
- Unhandled state transitions

## Requirements

- visionOS 2.0+
- Swift 5.9+
- RealityKit

## Package Structure

```
VibesParticles/
├── Sources/
│   └── VibesParticles/
│       ├── Core/           # Core AetherParticles implementation
│       ├── Effects/        # Pre-built effect configurations
│       └── Utils/          # Helper utilities and extensions
└── Tests/                  # Unit tests
```

## Usage

### Basic Particle System

```swift
import VibesParticles

// Create a particle system with a preset
let system = AetherParticles.withPreset(.fireflies)

// Add to your RealityKit scene
myEntity.addChild(system.rootEntity)

// Start the animation
system.start()
```

### SwiftUI Integration

```swift
AetherParticlesView(preset: .fireflies) { state in
    print("Particle state changed to: \(state)")
}
```

### Custom Configuration with RealityKit Colors

```swift
// Define colors using RealityKit's native color type
let startColor = ParticleEmitterComponent.ParticleEmitter.Color(
    red: 1.0,
    green: 0.0,
    blue: 0.0,
    alpha: 0.8
)

let config = AetherParticles.ParticleConfiguration(
    emitterShape: .sphere,
    emitterSize: [2, 2, 2],
    birthRate: 100,
    colorConfig: .evolving(
        start: .single(startColor),
        end: .single(endColor)
    ),
    acceleration: [0, 0.1, 0],
    speed: 0.5
)

system.update(with: config)
```

## Available Presets

- `.fireflies`: Gentle floating particles with rainbow colors
- `.galaxy`: Swirling galaxy formation with purple-blue gradient
- `.galaxySplit`: Split galaxy formation with individual swirls
- `.sparkles`: Bright white twinkling effect
- `.smoke`: Ethereal white smoke effect
- `.rain`: Falling particle effect

## Implementation Notes

- Uses RealityKit's ParticleEmitterComponent exclusively
- Implements efficient particle pooling through RealityKit
- Uses native RealityKit color system for optimal performance
- Provides proper cleanup and memory management
- Maintains proper visionOS 2.0+ availability attributes
- Designed for music visualization and immersive experiences

## License

This package is part of the Vibes project. 