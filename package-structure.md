# Vibes Package Structure

## Current Implementation: Hybrid/Monolithic Approach

### Phase 1: Core App with Essential Packages
Currently, we're using a hybrid approach with most functionality in the main app and only essential features as packages.

#### Main App Components
- Core UI and Navigation
- State Management
- Basic Visualization Logic
- Asset Management
- Configuration

#### Essential Packages
1. **PulsarSymphony** (formerly MusicService)
   - Apple Music integration
   - Audio session management
   - Playback controls
   - Music analysis

2. **AetherParticles**
   - Particle system core
   - Physics and behavior
   - Material management

### Future Extraction Candidates
These components will start in the main app and be extracted to packages as they stabilize:

1. **VibesEngine**
   - Music-to-visual mapping
   - Visualization configurations
   - Currently: Part of main app
   - Future: Separate package

2. **ImmersiveService**
   - Immersive space management
   - Scene transitions
   - Currently: Part of main app
   - Future: Separate package

3. **TrackingService**
   - Hand/Eye tracking
   - Gesture recognition
   - Currently: Part of main app
   - Future: Separate package

## Future Goal: VibeKit Umbrella Package

> Note: This structure represents the eventual goal after components have been stabilized and extracted.

### Core Package: VibeKit

VibeKit will serve as the umbrella package containing all core functionality modules. This structure allows for better organization, clear dependency management, and modular development.

```swift
import VibeKit
// Will provide access to all sub-modules
```

### Sub-Packages

#### 1. PulsarSymphony
```swift
import VibeKit.PulsarSymphony
// Provides: MusicAnalyzer, PlaybackState, etc.
```

#### 2. AetherParticles
```swift
import VibeKit.AetherParticles
// Provides: ParticleSystem, ParticleEmitter, etc.
```

#### 3. VibesEngine
```swift
import VibeKit.VibesEngine
// Will provide: VibeGenerator, AlbumAnalyzer, etc.
```

#### 4. ImmersiveService
```swift
import VibeKit.ImmersiveService
// Will provide: ImmersiveSpaceManager, SceneController, etc.
```

#### 5. TrackingService
```swift
import VibeKit.TrackingService
// Will provide: HandTrackingManager, GestureRecognizer, etc.
```

## Package Dependencies

```
Current Structure:
Vibes App
├── PulsarSymphony
│   ├── MusicKit
│   └── AVFAudio
└── AetherParticles
    ├── RealityKit
    └── Metal

Future VibeKit Structure:
VibeKit
├── PulsarSymphony
│   ├── MusicKit
│   └── AVFAudio
├── AetherParticles
│   ├── RealityKit
│   └── Metal
├── VibesEngine
│   ├── PulsarSymphony
│   └── AetherParticles
├── ImmersiveService
│   ├── RealityKit
│   └── ARKit
└── TrackingService
    └── ARKit
```

## Implementation Guidelines

1. **Monolithic First Principles:**
   - Keep new features in main app initially
   - Test and stabilize functionality
   - Identify clear boundaries before extraction
   - Document integration points

2. **Package Extraction Criteria:**
   - Feature is stable and well-tested
   - Clear public interface defined
   - Minimal dependencies on other components
   - Reusability potential identified

3. **Package Communication:**
   - Use protocols for interfaces
   - Implement proper error handling
   - Maintain version compatibility
   - Document breaking changes

4. **Testing Strategy:**
   - Unit tests in main app first
   - Extract tests with package creation
   - Maintain test coverage during extraction

## Benefits of Hybrid Approach

1. **Faster Initial Development**
   - Reduced complexity during early stages
   - Easier debugging and testing
   - Flexible architecture evolution

2. **Risk Management**
   - Core features as stable packages
   - Experimental features in main app
   - Controlled package extraction

3. **Better Module Design**
   - Natural boundary identification
   - Real-world usage patterns
   - Optimized public interfaces

4. **Team Workflow**
   - Clear separation of stable/experimental code
   - Focused package maintenance
   - Gradual learning curve