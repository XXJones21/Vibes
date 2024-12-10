# Vibes

A visionOS music visualization app that creates immersive spatial audio experiences.

## Project Status

## Current Progress (December 9, 2023)
The AetherParticles module has undergone significant improvements in its motion system. We've resolved issues with component overrides that were affecting particle behaviors, ensuring that each effect (galaxy and fireflies) now maintains its distinct characteristics. The core system has been updated to properly respect individual effect configurations, with improved component integration and debug logging in place.

### Top Priorities
1. Verify distinct particle behaviors in different scenarios
2. Monitor component state management and performance
3. Enhance debug visualization capabilities
4. Gradually reintroduce complex physics features
5. Optimize performance for large-scale effects

### Recent Achievements
- Fixed particle motion override issues in component systems
- Improved effect configuration inheritance
- Enhanced debug logging for better troubleshooting
- Simplified effect implementations for better stability

See `current-status.md` for detailed progress and `current-issues.md` for known issues.

## Current Focus
Working on improving AetherParticles visibility and coordinate space handling. Recent updates include proper coordinate space conversion using RealityKit's content.convert system, fixed entity positioning and scaling, and improved debug visualization. Next steps involve testing visibility across different scenarios and implementing performance monitoring.

## Top Priorities
1. Test AetherParticles visibility in different view sizes and scenarios
2. Implement performance monitoring for particle systems
3. Add proper cleanup handling for particle systems
4. Verify coordinate space conversion in edge cases

### Current Priorities
1. Complete particle system conversion and optimization
2. Test performance with multiple simultaneous particle systems
3. Finalize CSS/HTML particle effect conversions
4. Verify Dolby Atmos integration
5. Performance testing with 25+ AlbumVibes

## Current State
The module structure has been finalized with standardized naming (Aether prefix) and proper access levels. Core functionality and effects are organized into clear categories (Core, Presets, Animations) with consistent patterns. All public declarations have been reviewed and adjusted to appropriate access levels.

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
