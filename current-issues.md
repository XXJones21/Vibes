# Current Issues

## Resolved (2024-12-12)
- ✅ Fixed FirefliesEffect implementation issues
- ✅ Corrected ParticleEmitter API usage
- ✅ Resolved duplicate configuration files
- ✅ Fixed entity property access patterns

## Active Issues
1. Performance Testing Needed
   - Particle system behavior on device
   - Memory usage patterns
   - Frame rate impact

2. Integration Verification
   - Music reactivity with new implementation
   - Effect transitions
   - Configuration persistence

3. Documentation
   - Updated architecture diagrams needed
   - Performance optimization guidelines
   - New configuration patterns

## High Priority
1. Particle System Property Updates (⚠️ Critical)
   - **Issue**: Current `applyTo` implementation is inefficient and causes performance issues
     - Creates new emitter instances unnecessarily
     - Updates all properties every frame
     - Poor component lifecycle management
   
   **Implementation Plan**:
   1. ✅ Property Separation (Day 1) - COMPLETED
      - ✅ Split PulseEffect properties into static/dynamic
        ```swift
        public struct PulseStaticProperties {
            let emitterShape: EmitterShape
            let emitterSize: SIMD3<Float>
            let speed: Float
            let lifetime: Float
        }

        public struct PulseDynamicProperties {
            var birthRate: Float
            var color: PulseColor
            var acceleration: SIMD3<Float>
        }
        ```
      - ✅ Created new protocol methods for each type
        ```swift
        protocol PulseEffect {
            func applyStaticProperties(_ particleSystem: ParticleEmitterComponent)
            func updateDynamicProperties(_ particleSystem: ParticleEmitterComponent, deltaTime: Float)
        }
        ```
      - ✅ Added property observer system with dirty state tracking
      - ✅ Updated DefaultPulseEffect to use new system

   2. ✅ Component Management (Day 1-2) - COMPLETED
      - ✅ Implemented proper component reuse in PulseParticles
      - ✅ Added dirty state tracking
      - ✅ Created property observer system
        ```swift
        // Property observation system
        public protocol PropertyObserver: AnyObject {
            func propertyDidChange(_ keyPath: AnyKeyPath)
        }
        
        @propertyWrapper
        public struct Observable<T> {
            private var value: T
            private weak var observer: PropertyObserver?
            
            public var wrappedValue: T {
                get { value }
                set {
                    value = newValue
                    observer?.propertyDidChange(keyPath)
                }
            }
        }
        ```

   3. ✅ Update System (Day 2) - COMPLETED
      - ✅ Modified update loop for efficiency with BatchUpdateManager
        ```swift
        private class BatchUpdateManager {
            private let batchSize: Int = 10
            private let updateInterval: TimeInterval = 1.0 / 60.0
            
            func addUpdate(_ particleSystem: ParticleEmitterComponent, 
                          update: @escaping () -> Void) {
                pendingUpdates.append((particleSystem, up