# Vibes

A visionOS music visualization app that creates immersive spatial audio experiences.

## Project Status
As of December 8, 2023:
The AetherParticles module migration is complete with standardized namespace conventions and proper access levels. All effect files have been updated with the Aether prefix and organized into a clear module structure. Core functionality has been streamlined with consistent naming patterns and documentation. The focus now shifts to addressing platform availability requirements and performance optimization.

### Current Priorities:
1. Address platform availability linter errors (ObservableObject, Entity, etc.)
2. Test and optimize particle system performance
3. Verify animation timing against UX specs
4. Implement performance optimizations (entity pooling, batch updates)

## Current State
The module structure has been finalized with standardized naming (Aether prefix) and proper access levels. Core functionality and effects are organized into clear categories (Core, Presets, Animations) with consistent patterns. All public declarations have been reviewed and adjusted to appropriate access levels.

## Top Priorities
1. Fix platform availability errors in AetherParticles module
2. Optimize particle system performance
3. Verify animation timing and transitions
4. Implement performance improvements
5. Test with increased particle counts

### Current Progress (December 7, 2023)
Fixed particle system visibility issues by implementing correct RealityKit particle properties. Updated documentation with proper API usage and best practices. The welcome animation's particle system has been corrected with proper lifetime and size configurations.

### Current Priorities
1. Verify particle visibility in welcome animation
2. Implement additional particle features for enhanced effects
3. Test different particle configurations
4. Consider implementing advanced RealityKit particle properties

### Upcoming Features
- Robust particle system API
- Type-safe color configurations
- Efficient entity management
- Comprehensive error handling
- Unit test coverage

## Features

- Music playback integration with Apple Music
- Real-time audio visualization
- Particle system effects
- Spatial audio support
- Cross-platform compatibility
- Album browsing and management
- Customizable visualization settings

## Requirements

- Xcode 15.0+
- iOS 15.0+
- macOS 12.0+
- visionOS 1.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `Vibes.xcodeproj` in Xcode
3. Build and run the project

## Project Structure

```
Vibes/
├── Packages/
│   └── MusicService/           # Music integration package
│       ├── Sources/
│       │   └── MusicService/   # Core music service implementation
│       └── Tests/              # Unit tests
├── App/                        # Main app target
└── Documentation/              # Project documentation
```

## Architecture

- Protocol-based design for service abstraction
- SwiftUI for user interface
- MusicKit integration for music playback
- RealityKit for 3D visualization
- Modular package structure

## Current Status

See [current-status.md](current-status.md) for the latest implementation details.

## Known Issues

See [current-issues.md](current-issues.md) for current known issues and their status.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
