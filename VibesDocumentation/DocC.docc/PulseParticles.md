# ``PulseParticles``

A high-performance particle system manager for visionOS.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("PulseParticles")
}

## Overview

``PulseParticles`` is the core manager for particle effects in Vibes, handling multiple simultaneous effects with automatic performance optimization and spatial management.

```swift
// Create a particle system with maximum effects
let pulseParticles = PulseParticles(maxEffects: 5)

// Add effects
pulseParticles.addEffect(FirefliesEffect())
pulseParticles.addEffect(GalaxyEffect())

// Position and scale effects
pulseParticles.setPosition(for: effect, position: [0, 0, 0.25])
pulseParticles.scaleEffect(effect, to: 2.0)
```

## Topics

### Essentials

- ``init(maxEffects:)``
- ``rootEntity``
- ``activeEffects``

### Effect Management

- ``addEffect(_:)``
- ``removeEffect(_:)``
- ``removeAllEffects()``

### Spatial Control

- ``setPosition(for:position:)``
- ``scaleEffect(_:to:)``
- ``updateEffectSpacing()``

### Performance

- ``update(currentTime:)``
- ``performanceMetrics``
- ``detailedMetrics``

## Managing Effects

The particle system manages effect lifecycles and resources:

```swift
class PulseParticles: ObservableObject {
    // Maximum number of simultaneous effects
    private let maxSimultaneousEffects: Int
    
    // Active effects and their components
    @Published public private(set) var activeEffects: [ObjectIdentifier: PulseEffect]
    private var particleSystems: [ObjectIdentifier: ParticleEmitterComponent]
    private var effectEntities: [ObjectIdentifier: Entity]
    
    // Add a new effect
    @discardableResult
    public func addEffect(_ effect: PulseEffect) -> Bool {
        // Check capacity
        guard activeEffects.count < maxSimultaneousEffects else {
            return false
        }
        
        // Create and configure entity
        let effectEntity = Entity()
        effectEntity.position = [0, 0, 0.25]
        
        // Add particle system
        var particleSystem = ParticleEmitterComponent()
        effect.applyStaticProperties(&particleSystem)
        effectEntity.components.set(particleSystem)
        
        // Store references
        activeEffects[effectId] = effect
        particleSystems[effectId] = particleSystem
        effectEntities[effectId] = effectEntity
        
        return true
    }
}
```

### Performance Monitoring

The system includes comprehensive performance monitoring:

```swift
// Get basic metrics
let (activeCount, avgFPS) = pulseParticles.performanceMetrics

// Get detailed metrics
let metrics = pulseParticles.detailedMetrics
print("Active Effects: \(metrics.activeEffects)")
print("Average FPS: \(metrics.averageFrameRate)")
print("Average Update Time: \(metrics.averageUpdateTime)ms")
print("Peak Update Time: \(metrics.peakUpdateTime)ms")
```

### Batched Updates

Updates are processed in efficient batches:

```swift
private class BatchUpdateManager {
    private let batchSize: Int = 10
    private let updateInterval: TimeInterval = 1.0 / 60.0
    
    func processBatch(currentTime: TimeInterval) {
        // Process updates in batches of 10
        let batch = pendingUpdates.prefix(batchSize)
        for (_, update) in batch { update() }
    }
}
```

### Spatial Management

Effects are automatically positioned in 3D space:

```swift
// Set custom position
pulseParticles.setPosition(for: effect, position: [1, 0, 1])

// Scale effect
pulseParticles.scaleEffect(effect, to: 2.0)

// Effects maintain minimum spacing
private func updateEffectSpacing() {
    let minDistance: Float = 2.0
    for (id1, entity1) in effectEntities {
        for (id2, entity2) in effectEntities where id1 != id2 {
            let distance = simd_distance(entity1.position, entity2.position)
            if distance < minDistance {
                // Move effects apart
                let direction = simd_normalize(entity1.position - entity2.position)
                let adjustment = direction * (minDistance - distance) * 0.5
                entity1.position += adjustment
                entity2.position -= adjustment
            }
        }
    }
}
```

## Performance Guidelines

For optimal performance:

- Limit maximum simultaneous effects
- Monitor frame rates and update times
- Use batched updates
- Implement proper cleanup
- Cache frequently accessed data

## See Also

- ``PulseEffect``
- ``FirefliesEffect``
- ``GalaxyEffect``
- ``PulseSystemView``