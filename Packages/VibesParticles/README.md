# VibesParticles

A specialized particle system package for creating immersive visionOS experiences.

## Recent Updates (December 8, 2023)
- Standardized particle system bounds to ±12.5 units across all presets
- Improved animation phase transitions and particle persistence
- Enhanced particle spawning and movement mechanics
- Optimized memory usage by reusing particles between phases

## Features
- Standardized particle bounds for consistent behavior
- Preset configurations for common effects:
  - Fireflies (±12.5 units)
  - Galaxy (±12.5 units)
  - GalaxySplit (±12.5 units)
  - Sparkles (±12.5 units)
  - Smoke (±12.5 units)
  - Rain (±12.5 units)
- Smooth phase transitions with particle reuse
- Optimized for visionOS spatial experiences

## Usage

```swift
// Create a particle system with standard bounds
let particles = AetherParticles(configuration: .default)

// Use a preset
particles.update(with: .fireflies.configuration)

// Custom configuration
let config = AetherParticles.ParticleConfiguration(
    emitterShape: .sphere,
    emitterSize: [1, 1, 1],
    birthRate: 100,
    colorConfig: .randomRainbowColor(),
    bounds: AetherParticles.standardBounds,  // Uses standard ±12.5 bounds
    acceleration: [0, 0, 0],
    speed: 0.1,
    lifetime: 4.0
)
particles.update(with: config)
```

## Requirements
- visionOS 2.0+
- Swift 5.9+
- RealityKit

## Known Issues
- Platform availability attributes need updating
- Performance testing needed with standardized bounds
- Documentation updates pending for new features

## Next Steps
1. Address platform availability linter errors
2. Add performance monitoring
3. Update documentation with new standards
4. Add examples for particle reuse patterns