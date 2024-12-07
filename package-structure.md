# Vibes Package Structure

> **Note**: The VibeKit umbrella package structure described below is a future task. Currently, the project uses individual packages (MusicService, VibesParticles) directly.

## Core Package: VibeKit (Future Implementation)

VibeKit serves as the umbrella package containing all core functionality modules. This structure allows for better organization, clear dependency management, and modular development.

```swift
import VibeKit
// Provides access to all sub-modules
```

### Sub-Packages

#### 1. MusicAnalytics (formerly MusicService)
- Apple Music integration
- Audio session management
- Playback controls
- Music analysis and feature extraction
swift
import VibeKit.MusicAnalytics
// Provides: MusicAnalyzer, PlaybackState, etc.
```

#### 2. AetherParticles (formerly VibesParticles)
- Particle system core
- Physics and behavior
- Material management
```swift
import VibeKit.AetherParticles
// Provides: ParticleSystem, ParticleEmitter, etc.
```

#### 3. VisualizationEngine
- Coordinates between MusicAnalytics and AetherParticles
- Handles music-to-visual mapping
- Manages visualization configurations
```swift
import VibeKit.VisualizationEngine
// Provides: VibeGenerator, AlbumAnalyzer, etc.
```

#### 4. ImmersiveService (Future)
- Manages immersive spaces
- Handles scene transitions
- Coordinates spatial audio
```swift
import VibeKit.ImmersiveService
// Will provide: ImmersiveSpaceManager, SceneController, etc.
```

#### 5. TrackingService (Future)
- Hand tracking integration
- Eye tracking features
- Gesture recognition
```swift
import VibeKit.TrackingService
// Will provide: HandTrackingManager, GestureRecognizer, etc.
```

## Package Dependencies

```
VibeKit
├── MusicAnalytics
│   ├── MusicKit
│   └── AVFAudio
├── AetherParticles
│   ├── RealityKit
│   └── Metal
├── VisualizationEngine
│   ├── MusicAnalytics
│   └── AetherParticles
├── ImmersiveService
│   ├── RealityKit
│   └── ARKit
└── TrackingService
    └── ARKit
```

## Package Structure

```
VibeKit/
├── Package.swift
├── Sources/
│   ├── VibeKit/           # Umbrella module
│   ├── MusicAnalytics/     # Music analysis and playback
│   ├── AetherParticles/    # Particle system
│   ├── VisualizationEngine/# Visualization coordination
│   ├── ImmersiveService/   # (Future) Immersive features
│   └── TrackingService/    # (Future) Tracking features
└── Tests/
    ├── MusicAnalyticsTests/
    ├── AetherParticlesTests/
    └── VisualizationEngineTests/
```
## Benefits

1. **Single Import Point**
   - Clean app-level imports
   - Unified versioning
   - Coordinated releases

2. **Modularity**
   - Clear separation of concerns
   - Independent feature development
   - Easier testing and mocking

3. **Scalability**
   - Packages can evolve independently
   - New features can be added as sub-packages
   - Team can work on different modules

4. **Maintenance**
   - Isolated bug fixes
   - Focused testing
   - Clear dependency boundaries

## Implementation Guidelines

1. Each sub-package should:
   - Have its own test suite
   - Include proper documentation
   - Define clear public interfaces
   - Handle its own dependencies

2. Package Communication:
   - Use protocols for interfaces
   - Implement proper error handling
   - Maintain version compatibility
   - Document breaking changes

3. Visualization Flow:
```swift
// Example coordination in VisualizationEngine
class VibeGenerator {
    func generateVibe(for album: Album) -> VibeConfiguration {
        let analysis = AlbumAnalyzer.analyze(album)
        return AetherParticlesConfig(
            energy: analysis.energy,
            mood: analysis.mood,
            tempo: analysis.tempo
        )
    }
}

```
</```rewritten_file>```
