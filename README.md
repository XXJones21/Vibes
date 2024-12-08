# Vibes

A visionOS music visualization app that creates immersive spatial audio experiences.

## Project Status
As of December 8, 2023:
The PulsarSymphony module migration is now complete with proper access levels and file organization. Core functionality has been streamlined with redundant types removed and proper module structure verified. The focus now shifts to addressing platform availability requirements and performance optimization.

### Current Priorities:
1. Address platform availability linter errors (ObservableObject, Entity, etc.)
2. Verify and optimize animation timing and performance
3. Complete remaining project repair tasks
4. Test particle system with new standardized bounds

## Current State
The module structure has been finalized with proper access levels and namespace alignment. Package dependencies have been cleaned up, retaining only RealityKitContent and VibesParticles. Core functionality is maintained with better consistency and organization.

## Top Priorities
1. Address platform availability linter errors
2. Verify animation timing against UX specifications
3. Test and optimize particle system performance
4. Consider additional particle effects for other views
5. Complete comprehensive testing with new bounds

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
