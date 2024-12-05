# Vibes - Spatial Audio Music Player

A visionOS music player app that creates immersive spatial audio experiences.

## Project Status (December 5, 2023)

The project has reached a significant milestone with the implementation of the welcome animation system. The new particle-based welcome screen provides an immersive introduction to the app, featuring a dynamic 10-second animation sequence that transforms between various states. The animation system is optimized for visionOS with proper batch processing and memory management. Focus is now shifting to enhancing the core music browsing and playback experience.

### Current Priorities
1. 🎨 Complete welcome animation system
2. 🌟 Enhance Gallery view with animations and effects
3. 🎵 Improve music lookup and track data handling
4. 🎧 Implement Now Playing view with transitions
5. ⚡️ Optimize MusicService package performance

### Upcoming Features
- Enhanced album browsing experience
- Seamless view transitions
- Comprehensive track information
- Interactive Now Playing view
- Optimized music lookup system

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
