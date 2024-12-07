# Vibes - Spatial Audio Music Player

A visionOS music player app that creates immersive spatial audio experiences.

## Project Status

## Current State
Created detailed implementation plan for MusicService optimization with focus on early initialization, enhanced album model, memory management, and preview system integration. Established clear progress tracking system and phase-based development approach. Core functionality remains stable with standardized particle system bounds and improved animations.

## Development Progress

### Gallery View
Enhancing with improved animations and more dynamic interactions

### [MusicService Optimization (In Progress)](project-planning.md#musicservice-optimization-plan)

#### Phase 1: Early Initialization & Preloading
- [x] Service initialization at app launch
- [ ] Prioritized loading strategy implementation
- [ ] Progress tracking system

#### Phase 2: Enhanced Album Model
- [x] Basic Album structure
- [x] Initial metadata handling
- [ ] Comprehensive Album structure
- [ ] TrackMetadata system
- [ ] AlbumManager with caching

#### Phase 3: Memory & Performance Management
- [ ] Tiered caching system
- [ ] Predictive loading
- [ ] Resource management protocols

#### Phase 4: Preview & Vibe System Integration
- [ ] Preview manager
- [ ] Hover detection system
- [ ] Preview playback system

### NowPlaying View
Beginning development with focus on seamless integration

### Current Progress (December 8, 2023)
- Created comprehensive MusicService optimization plan
- Established phase-based development approach
- Set up progress tracking system
- Moved implementation details to dedicated planning document
- Maintained core functionality and animation improvements

### Current Priorities
1. Begin implementing MusicService Phase 1 components
2. Continue refining particle system performance
3. Prepare for NowPlaying view development
4. Address platform availability attributes

## Top Priorities
1. Address platform availability linter errors
2. Verify animation timing against UX specifications
3. Test and optimize particle system performance
4. Consider additional particle effects for other views
5. Complete comprehensive testing with new bounds

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
│   ├── MusicService/           # Music integration package
│   ├── VibesParticles/        # Particle system package
│   └── RealityKitContent/     # Reality content resources
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
