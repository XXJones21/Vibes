# Vibes - Spatial Audio Music Player

A visionOS music player app that creates immersive spatial audio experiences.

## Project Status (December 5, 2023)

The project has achieved a significant milestone with working music playback functionality. Album grid view is now fully operational with proper artwork loading and immediate playback on selection. Key Apple Music integration issues have been resolved by implementing proper catalog ID handling and adding required entitlements. The codebase maintains strict visionOS 2.0 compatibility with proper availability attributes.

### Current Priorities
1. 🎵 Implement Now Playing view for active playback
2. 🎮 Add gesture-based playback controls
3. 💫 Polish UI transitions and animations
4. 🔊 Develop spatial audio visualization

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
