# Vibes - Spatial Audio Music Player

A visionOS music player app that creates immersive spatial audio experiences.

## Project Status (December 6, 2023)

The project has made significant progress in package architecture and type system improvements. The VibesParticles package has been restructured with proper access levels and RealityKit type exposure. A new ParticleTypes system has been implemented to handle color configurations and emitter shapes. Current focus is on resolving remaining access level issues and improving package integration.

### Current Priorities
1. 🔒 Fix remaining access level issues
2. 🎨 Resolve RealityKit type availability
3. 📦 Improve package integration
4. 📝 Add comprehensive documentation
5. ⚡️ Optimize performance

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
