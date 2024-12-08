# Current Issues

## HIGH PRIORITY: AetherParticles Migration Plan
Convert package to module structure:

1. ✅ **Create Module Structure** 
   ```
   Vibes/Modules/AetherParticles/
   ├── Core/
   │   ├── System/
   │   │   └── AetherSystem.swift (RealityKit System implementation)
   │   ├── AetherParticles.swift (Main API)
   │   ├── AetherParticlesView.swift (SwiftUI integration)
   │   └── AetherParticleTypes.swift (Shared types)
   └── Effects/
       ├── AetherPresets/
       │   ├── FirefliesEffect.swift
       │   ├── GalaxyEffect.swift
       │   ├── GalaxySplitEffect.swift
       │   ├── RainEffect.swift
       │   ├── SmokeEffect.swift
       │   └── SparklesEffect.swift
       └── AetherAnimations/
           └── WelcomeLetterAnimation.swift
   ```

2. ✅ **File Migration Steps** (via Xcode)
   1. ✅ Create directory structure
   2. ✅ Copy and rename core files:
      - ✅ ParticleSystem.swift → Core/AetherParticles.swift
      - ✅ ParticleTypes.swift → Core/AetherParticleTypes.swift
      - ✅ AetherSystem.swift → Core/System/AetherSystem.swift
      - ✅ AetherParticlesView.swift (Added for SwiftUI integration)
   3. ✅ Copy effects files:
      - ✅ Presets/ → AetherPresets/ (with standardized ±12.5 unit bounds)
      - ✅ Animations/ → AetherAnimations/

3. ✅ **Update Namespace**
   - Core updates complete:
     - ✅ Removed Core.swift (functionality moved to AetherSystem)
     - ✅ Updated AetherSystem.swift registration
     - ✅ AetherParticles.swift updated:
         - ✅ Removed public access modifiers
         - ✅ Added Aether prefix to types
         - ✅ Updated documentation
     - ✅ AetherParticleTypes.swift updated:
         - ✅ Removed public access modifiers
         - ✅ Added Aether prefix to types
         - ✅ Updated documentation
     - ✅ AetherParticlesView.swift in place
   - Effects updates complete:
     - ✅ AetherPresets/:
         - ✅ AetherFirefliesEffect
         - ✅ AetherGalaxyEffect
         - ✅ AetherGalaxySplitEffect
         - ✅ AetherRainEffect
         - ✅ AetherSmokeEffect
         - ✅ AetherSparklesEffect
     - ✅ AetherAnimations/:
         - ✅ AetherWelcomeAnimation
   - ✅ Namespace Naming Convention:
     - ✅ Update type names to include "Aether" prefix:
       - ✅ AetherParticleTypes.swift
       - ✅ AetherParticles.swift
       - ✅ Effects files
     - ✅ Standardize naming across all files:
       - Types: AetherColor, AetherShape, etc.
       - Enums: AetherColorMode, AetherState, etc.
       - Configurations: AetherConfiguration, etc.

4. **Code Adjustments** (Next Steps)
   - ✅ Remove package-specific declarations
   - ✅ Update access levels (public → internal where appropriate)
   - ✅ Adjust file organization to match module structure
   - ✅ Update any package-dependent paths
   - ✅ Ensure consistent naming convention across all Aether prefixed types
   - Implement performance optimizations:
     - Entity pooling
     - Batch updates
     - Memory management
     - Frame rate optimization

## Current Focus
- ✅ Fixing RealityKit system registration in AetherSystem.swift
- ✅ Updating access levels across all files
- ✅ Verifying namespace consistency

## Platform Availability
- Several linter errors related to macOS/visionOS availability:
  - ObservableObject
  - Entity
  - Published
  - BoundingBox
  - RealityViewContent
  - Point3D
- Need to verify and update availability attributes

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