# Current Issues (December 9, 2023)

## AetherParticles Module

### 🔴 HIGH PRIORITY: Factory Pattern Implementation
Implementation plan to resolve duplicate ParticleEmitterComponent issue:

1. **Step 1: Create Factory Class**
```swift
@available(visionOS 2.0, *)
final class AetherParticlesFactory {
    static func create(preset: AetherParticles.AetherPreset, isLargeScale: Bool) -> AetherParticles {
        let config = preset.configuration
        return AetherParticles(configuration: config, isLargeScale: isLargeScale)
    }
}
```

2. **Step 2: Modify AetherParticlesView**
```swift
@available(visionOS 2.0, *)
public struct AetherParticlesView: View {
    @StateObject private var state: AetherParticlesState
    
    public init(preset: Preset, isLargeScale: Bool = false) {
        let particles = AetherParticlesFactory.create(preset: preset, isLargeScale: isLargeScale)
        _state = StateObject(wrappedValue: AetherParticlesState(particles: particles))
    }
}
```

3. **Step 3: Update AetherParticles Setup**
```swift
@available(visionOS 2.0, *)
final class AetherParticles {
    private func setupEmitter() {
        // 1. Create base emitter
        let emitter = createBaseEmitter()
        _rootEntity.components.set(emitter)
        
        // 2. Add behavior component
        if isLargeScale {
            setupNexusComponent(with: configuration)
        } else {
            setupPulseComponent(with: configuration)
        }
    }
    
    private func createBaseEmitter() -> ParticleEmitterComponent {
        var emitter = ParticleEmitterComponent()
        // Configure base emitter properties
        return emitter
    }
    
    private func setupNexusComponent(with config: AetherConfiguration) {
        var nexus = NexusComponent(colorConfig: config.colorConfig)
        // Configure nexus properties from base config
        _rootEntity.components.set(nexus)
    }
    
    private func setupPulseComponent(with config: AetherConfiguration) {
        var pulse = PulseComponent(colorConfig: config.colorConfig)
        // Configure pulse properties from base config
        _rootEntity.components.set(pulse)
    }
}
```

4. **Step 4: Update Component Behavior**
```swift
@available(visionOS 2.0, *)
public struct NexusComponent: Component {
    public mutating func didAddToEntity(_ entity: Entity) {
        // Only modify particle behavior, don't create new emitter
        if let emitter = entity.components[ParticleEmitterComponent.self] {
            updateEmitterBehavior(emitter)
        }
    }
    
    private func updateEmitterBehavior(_ emitter: ParticleEmitterComponent) {
        // Apply Nexus-specific modifications to existing emitter
    }
}
```

5. **Step 5: Update Systems**
```swift
@available(visionOS 2.0, *)
public class NexusSystem: System {
    private func updateNexusEmitter(entity: Entity, emitter: ParticleEmitterComponent, nexus: NexusComponent, deltaTime: TimeInterval) {
        // Only modify behavior, don't replace emitter
        var updatedEmitter = emitter
        // Apply nexus behavior updates
        entity.components[ParticleEmitterComponent.self] = updatedEmitter
    }
}
```

Key Changes:
1. Factory handles creation and configuration
2. Components focus on behavior modification
3. Single source of truth for ParticleEmitterComponent
4. Clear separation between creation and behavior

### Component System
1. Component Override Issues:
   - ✅ Fixed: NexusComponent overriding effect configurations
   - ✅ Fixed: PulseComponent affecting particle behavior
   - 🔍 Monitoring: Component state persistence
   - 🔍 Monitoring: Performance impact of configuration updates

2. Effect Behaviors:
   - ✅ Fixed: Particle motion direction issues
   - ✅ Fixed: Configuration inheritance
   - 🔍 Testing: Galaxy disk formation stability
   - 🔍 Testing: Fireflies natural motion

3. Performance:
   - 🔍 Monitoring: Component update cycle efficiency
   - 🔍 Monitoring: Particle count impact
   - ⏳ Pending: Complex physics reintegration
   - ⏳ Pending: Optimization for large-scale effects

### Debug System
1. Logging:
   - ✅ Added: Component state logging
   - ✅ Added: Configuration update tracking
   - ⏳ Pending: Performance metrics
   - ⏳ Pending: Visual debug helpers

## Priority Order
1. 🔴 Verify distinct effect behaviors
2. 🔴 Monitor component state management
3. 🟡 Assess performance impact
4. 🟡 Enhance debug visualization
5. 🟢 Reintroduce complex physics