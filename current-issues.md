# Current Issues

## High Priority

### AetherParticles Restructuring (HIGH PRIORITY)

#### Current Status
- Build errors in PulseSystem and NexusSystem
- Directory structure needs reorganization
- Access level issues between components
- Type conversion issues in particle configurations
- ⚠️ NEW: NexusSystem has incorrect RealityKit System registration (Scene.registerSystem/unregisterSystem not found)
- ⚠️ NEW: Inconsistency between PulseSystem (standalone) and NexusSystem (RealityKit System) approaches
- ⚠️ NEW: AetherPhysics moved to Core level but some imports may need updating

#### Required Changes

1. Directory Restructuring:
```
AetherParticles/
├── Core/
│   ├── AetherPhysics.swift        # Moved here
│   ├── AetherParticles.swift
│   ├── AetherConfiguration.swift
│   └── AetherParticleTypes.swift
├── Systems/
│   ├── Pulse/
│   │   ├── PulseSystem.swift
│   │   └── PulseComponent.swift
│   └── Nexus/
│       ├── NexusSystem.swift
│       └── NexusComponent.swift
└── Effects/
    ├── AetherPresets/
    └── AetherAnimations/
```

2. Access Level Updates:
- Make AetherConfiguration public and accessible to both systems
- Ensure standardBounds is accessible where needed
- Update component access levels for proper encapsulation
- ⚠️ NEW: Verify AetherPhysics access levels after Core move

3. System-Specific Changes:

**PulseSystem (Apple's Approach)**
- Optimize for small, localized effects
- Focus on performance with multiple instances
- Update to use proper type conversions (Float/Double)
- Maintain compatibility with RealityKit particle system

**NexusSystem (Custom Approach)**
- Keep existing complex physics capabilities
- ⚠️ NEW: Fix RealityKit System registration issues
- ⚠️ NEW: Implement correct Scene-based system registration
- ⚠️ NEW: Consider performance implications of System vs standalone
- Maintain scene-wide particle management
- Preserve existing effect quality

4. Integration Points:
- Both systems should use AetherConfiguration
- Standardize particle property access
- Maintain existing preset compatibility
- Keep SwiftUI integration working
- ⚠️ NEW: Ensure AetherPhysics properly integrated with both systems

#### Success Criteria
1. Clean build with no errors
2. All existing effects working as before
3. Both systems accessible through AetherParticles class
4. No loss of functionality in either system
5. Clear separation of concerns between systems
6. Proper access to shared configurations
7. ⚠️ NEW: Verified performance with large-scale particle simulations

#### Implementation Steps
1. ✅ Create new directory structure
2. ✅ Move files to new locations
3. Update imports and access levels
4. Fix type conversion issues
5. Test each system independently
6. Verify integration points
7. Update documentation
8. ⚠️ NEW: Fix NexusSystem registration
9. ⚠️ NEW: Performance testing with both systems

## Platform Availability
- Several linter errors related to macOS/visionOS availability:
  - ObservableObject
  - Entity
  - Published
  - BoundingBox
  - RealityViewContent
  - Point3D
- Need to verify and update availability attributes
- ⚠️ NEW: Scene.registerSystem availability needs verification

## Animation System
- Animation timing needs verification against UX specs
- Particle counts may need optimization for performance
- Some phases might need fine-tuning:
  - Globe formation initial spread
  - Center pull transition smoothness
  - Text formation particle distribution

## Performance Considerations
- Test increased particle counts impact
- Verify memory usage with expanded bounds
- Monitor frame rate during phase transitions

## Next Steps
1. ✅ Update Effects files with Aether prefix
2. Address platform availability errors
3. Test and optimize particle system performance
4. Verify animation timing matches UX design

## December 8, 2023 Update

### Resolved
- ✅ RealityKitContent package integration
- ✅ VibesParticles module dependencies
- ✅ AetherSystem deprecation
- ✅ Project structure cleanup

### Current Focus
- Implement new particle systems using RealityKit
- Optimize performance for multiple simultaneous particle systems
- Complete conversion of remaining CSS/HTML particle effects
- Test particle system performance with 25+ AlbumVibes

## Medium Priority
(existing medium priority issues...)

## Low Priority
(existing low priority issues...)

## Resolved Issues (January 24, 2024)

- ✅ Fixed Xcode/Cursor sync issues by properly saving project file changes
- ✅ Resolved folder structure inconsistencies by renaming `Modules` to `TechStacks`
- ✅ Fixed project file references to match new directory structure

## Current Issues

- ⏳ AetherParticles migration still in progress
- ⚠️ Need to verify all particle system functionality after reorganization
- ⚠️ Some import statements may need updating after structure changes