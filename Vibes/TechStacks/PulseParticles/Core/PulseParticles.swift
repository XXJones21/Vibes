import RealityKit
import Foundation
import QuartzCore

/// Manages batched updates for particle systems
private class BatchUpdateManager {
    private var pendingUpdates: [(ParticleEmitterComponent, () -> Void)] = []
    private let batchSize: Int = 10
    private let updateInterval: TimeInterval = 1.0 / 60.0 // 60fps target
    private var lastBatchUpdate: TimeInterval = 0
    
    func addUpdate(_ particleSystem: ParticleEmitterComponent, update: @escaping () -> Void) {
        pendingUpdates.append((particleSystem, update))
    }
    
    func processBatch(currentTime: TimeInterval) {
        guard currentTime - lastBatchUpdate >= updateInterval else { return }
        
        // Process updates in batches
        let updateCount = min(batchSize, pendingUpdates.count)
        let batch = pendingUpdates.prefix(updateCount)
        
        for (_, update) in batch {
            update()
        }
        
        // Remove processed updates
        pendingUpdates.removeFirst(updateCount)
        lastBatchUpdate = currentTime
    }
    
    var hasPendingUpdates: Bool {
        !pendingUpdates.isEmpty
    }
}

/// Main class for managing pulse particle effects
@available(visionOS 2.0, *)
public class PulseParticles: ObservableObject {
    // MARK: - Properties
    
    /// The root entity containing all particle systems
    @Published public private(set) var rootEntity: Entity
    
    /// Currently active effects
    @Published public private(set) var activeEffects: [ObjectIdentifier: PulseEffect] = [:]
    
    /// Particle systems for each effect
    private var particleSystems: [ObjectIdentifier: ParticleEmitterComponent] = [:]
    
    /// Effect entities for spatial management
    private var effectEntities: [ObjectIdentifier: Entity] = [:]
    
    /// Last update timestamp
    private var lastUpdateTime: TimeInterval = 0
    
    /// Maximum number of simultaneous effects
    private let maxSimultaneousEffects: Int
    
    /// Performance monitoring
    private var frameRates: [Double] = []
    private let maxFrameRateHistory = 60
    
    /// Metrics for performance monitoring
    private struct UpdateMetrics {
        var updateCount: Int = 0
        var totalUpdateTime: TimeInterval = 0
        var peakUpdateTime: TimeInterval = 0
        var averageUpdateTime: TimeInterval {
            updateCount > 0 ? totalUpdateTime / Double(updateCount) : 0
        }
        
        mutating func recordUpdate(duration: TimeInterval) {
            updateCount += 1
            totalUpdateTime += duration
            peakUpdateTime = max(peakUpdateTime, duration)
        }
        
        mutating func reset() {
            updateCount = 0
            totalUpdateTime = 0
            peakUpdateTime = 0
        }
    }
    
    private let batchManager = BatchUpdateManager()
    private var updateMetrics: UpdateMetrics
    
    // MARK: - Initialization
    
    /// Create a new PulseParticles instance
    /// - Parameter maxEffects: Maximum number of simultaneous effects (default: 5)
    public init(maxEffects: Int = 5) {
        self.rootEntity = Entity()
        self.maxSimultaneousEffects = maxEffects
        self.updateMetrics = UpdateMetrics()
        print("🎵 PulseParticles: Initialized with max \(maxEffects) effects")
    }
    
    // MARK: - Effect Management
    
    /// Add a new effect
    /// - Parameter effect: The effect to add
    /// - Returns: True if effect was added successfully
    @discardableResult
    public func addEffect(_ effect: PulseEffect) -> Bool {
        let effectId = ObjectIdentifier(effect as AnyObject)
        
        // Check if we're at capacity
        if activeEffects.count >= maxSimultaneousEffects {
            print("⚠️ Cannot add effect: Maximum number of effects reached")
            return false
        }
        
        // Create entity for this effect
        let effectEntity = Entity()
        
        // Position slightly forward
        effectEntity.position = [0, 0, 0.25]
        
        // Create or reuse particle system
        var particleSystem = particleSystems[effectId] ?? ParticleEmitterComponent()
        effect.currentParticleSystem = particleSystem
        
        // Apply static properties if needed
        if effect.isDirty {
            effect.applyStaticProperties(&particleSystem)
        }
        
        // Initial dynamic properties update
        effect.updateDynamicProperties(&particleSystem, deltaTime: 0)
        
        // Add to entity
        effectEntity.components.set(particleSystem)
        
        // Store references
        activeEffects[effectId] = effect
        particleSystems[effectId] = particleSystem
        effectEntities[effectId] = effectEntity
        
        // Add to root
        rootEntity.addChild(effectEntity)
        
        print("✨ Added effect: \(type(of: effect))")
        return true
    }
    
    /// Remove an effect
    /// - Parameter effect: The effect to remove
    public func removeEffect(_ effect: PulseEffect) {
        let effectId = ObjectIdentifier(effect as AnyObject)
        
        // Remove from active effects
        activeEffects.removeValue(forKey: effectId)
        
        // Remove particle system
        particleSystems.removeValue(forKey: effectId)
        
        // Remove entity
        if let entity = effectEntities.removeValue(forKey: effectId) {
            entity.removeFromParent()
        }
        
        print("🗑️ Removed effect: \(type(of: effect))")
    }
    
    /// Remove all effects
    public func removeAllEffects() {
        activeEffects.removeAll()
        particleSystems.removeAll()
        effectEntities.values.forEach { $0.removeFromParent() }
        effectEntities.removeAll()
        print("🧹 Removed all effects")
    }
    
    // MARK: - Update Loop
    
    /// Update all active effects
    /// - Parameter currentTime: Current time for delta calculation
    public func update(currentTime: TimeInterval) {
        let updateStart = CACurrentMediaTime()
        
        // Calculate delta time
        let deltaTime = lastUpdateTime > 0 ? Float(currentTime - lastUpdateTime) : 0
        lastUpdateTime = currentTime
        
        // Update frame rate tracking
        updatePerformanceMetrics(deltaTime: deltaTime)
        
        // Queue updates for each effect
        for (effectId, effect) in activeEffects {
            if var particleSystem = particleSystems[effectId] {
                // Queue dynamic property updates
                batchManager.addUpdate(particleSystem) {
                    effect.updateDynamicProperties(&particleSystem, deltaTime: deltaTime)
                }
                
                // Store updated particle system
                particleSystems[effectId] = particleSystem
                
                // Handle completed effects
                if case .completed = effect.state {
                    removeEffect(effect)
                }
            }
        }
        
        // Process batched updates
        batchManager.processBatch(currentTime: currentTime)
        
        // Record metrics
        let updateDuration = CACurrentMediaTime() - updateStart
        updateMetrics.recordUpdate(duration: updateDuration)
        
        // Reset metrics periodically
        if updateMetrics.updateCount >= 600 { // Reset every 10 seconds at 60fps
            updateMetrics.reset()
        }
    }
    
    // MARK: - Performance Management
    
    private func updatePerformanceMetrics(deltaTime: Float) {
        // Calculate frame rate
        let frameRate = 1.0 / Double(deltaTime)
        frameRates.append(frameRate)
        
        // Keep history limited
        if frameRates.count > maxFrameRateHistory {
            frameRates.removeFirst()
        }
        
        // Check if we need to reduce effects
        let averageFrameRate = frameRates.reduce(0, +) / Double(frameRates.count)
        if averageFrameRate < 30 && !activeEffects.isEmpty {
            print("⚠️ Low frame rate detected (\(Int(averageFrameRate)) FPS), reducing effects")
            if let (effectId, effect) = activeEffects.first {
                removeEffect(effect)
            }
        }
    }
    
    /// Get current performance metrics
    public var performanceMetrics: (activeEffects: Int, averageFrameRate: Double) {
        let avgFPS = frameRates.isEmpty ? 0 : frameRates.reduce(0, +) / Double(frameRates.count)
        return (activeEffects.count, avgFPS)
    }
    
    /// Get detailed performance metrics
    public var detailedMetrics: (
        activeEffects: Int,
        averageFrameRate: Double,
        averageUpdateTime: TimeInterval,
        peakUpdateTime: TimeInterval
    ) {
        (
            activeEffects.count,
            frameRates.isEmpty ? 0 : frameRates.reduce(0, +) / Double(frameRates.count),
            updateMetrics.averageUpdateTime,
            updateMetrics.peakUpdateTime
        )
    }
    
    // MARK: - Effect Interaction
    
    /// Update effect positions to maintain minimum distance
    private func updateEffectSpacing() {
        let minDistance: Float = 2.0 // Minimum distance between effects
        
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
    
    /// Set the position of a specific effect
    /// - Parameters:
    ///   - effect: The effect to position
    ///   - position: New position in 3D space
    public func setPosition(for effect: PulseEffect, position: SIMD3<Float>) {
        let effectId = ObjectIdentifier(effect as AnyObject)
        effectEntities[effectId]?.position = position
        updateEffectSpacing()
    }
    
    /// Scale a specific effect
    /// - Parameters:
    ///   - effect: The effect to scale
    ///   - scale: Scale factor to apply
    public func scaleEffect(_ effect: PulseEffect, to scale: Float) {
        let effectId = ObjectIdentifier(effect as AnyObject)
        if let entity = effectEntities[effectId] {
            entity.transform.scale = SIMD3<Float>(repeating: scale)
            effect.adjustEmissionVolume(scale: scale)
        }
    }
} 