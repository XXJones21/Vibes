# Particle System Update Optimization Proposal

## Overview
Improve performance and efficiency of particle effect updates by implementing a more granular update system that separates static and dynamic properties, caches particle systems, and provides property-level updates.

## Current Implementation
- Creates new emitter configuration on every update
- Rebuilds all properties regardless of what changed
- No caching of particle systems or properties
- No distinction between static and dynamic properties

## Proposed Changes

### 1. Property Observer System

```swift
public protocol PulseEffect {
    // New properties
    var currentParticleSystem: ParticleEmitterComponent? { get set }
    var isDirty: Bool { get set }  // Tracks if static properties need update
    
    // New methods
    func markDirty()
    func cleanIfNeeded()
}

extension PulseEffect {
    func updateProperty<T: Equatable>(_ property: inout T, newValue: T) {
        if property != newValue {
            property = newValue
            markDirty()
        }
    }
}
```

Benefits:
- Efficient property updates
- Automatic dirty state tracking
- Reduced unnecessary updates

### 2. Particle System Caching

```swift
public class PulseParticles {
    // Add to existing properties
    private var cachedSystems: [ObjectIdentifier: ParticleEmitterComponent] = [:]
    
    // Modify addEffect method
    public func addEffect(_ effect: PulseEffect) -> Bool {
        let effectId = ObjectIdentifier(effect as AnyObject)
        
        // Reuse cached system if available
        let particleSystem = cachedSystems[effectId] ?? ParticleEmitterComponent()
        effect.currentParticleSystem = particleSystem
        
        // Only apply full configuration if needed
        if effect.isDirty {
            effect.applyTo(particleSystem)
            effect.cleanIfNeeded()
        }
        
        // Cache the system
        cachedSystems[effectId] = particleSystem
        // ... rest of existing code
    }
}
```

Benefits:
- Reduced memory allocation
- Faster effect switching
- Better resource management

### 3. Property Type Separation

```swift
public protocol PulseEffect {
    // New property groups
    var staticProperties: PulseStaticProperties { get }
    var dynamicProperties: PulseDynamicProperties { get }
    
    // Split update methods
    func applyStaticProperties(_ particleSystem: ParticleEmitterComponent)
    func updateDynamicProperties(_ particleSystem: ParticleEmitterComponent, deltaTime: Float)
}

public struct PulseStaticProperties {
    let emitterShape: EmitterShape
    let emitterSize: SIMD3<Float>
    let speed: Float
    // ... other non-changing properties
}

public struct PulseDynamicProperties {
    var color: PulseColor
    var birthRate: Float
    // ... other time-varying properties
}
```

Benefits:
- Clear separation of concerns
- Optimized update cycles
- Better performance profiling

## Implementation Plan

1. Phase 1: Core Updates
   - Add property observer system to PulseEffect protocol
   - Implement caching in PulseParticles class
   - Create property type structures

2. Phase 2: Effect Updates
   - Update FirefliesEffect to use new system
   - Update GalaxyEffect to use new system
   - Add migration support for existing effects

3. Phase 3: Performance Optimization
   - Add performance monitoring for property updates
   - Implement batch updates for multiple properties
   - Add debug logging for update patterns

## Migration Strategy
- Maintain backward compatibility with existing effects
- Provide extension methods for easy adoption
- Add documentation and examples for new patterns

## Risks and Mitigations
- Memory usage from caching: Implement cache clearing strategy
- Complexity increase: Provide clear documentation and examples
- Performance overhead: Monitor and optimize observer system
``` 