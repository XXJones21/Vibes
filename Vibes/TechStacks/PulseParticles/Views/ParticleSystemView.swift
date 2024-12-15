import SwiftUI
import RealityKit

/// A SwiftUI view that displays pulse particle effects using RealityKit
@available(visionOS 2.0, *)
public struct PulseSystemView: View {
    // MARK: - Properties
    
    /// The particle system manager
    private let particles: PulseParticles
    
    /// RealityKit view state
    @State private var showContent = false
    
    /// Update timer for particle system
    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    // MARK: - Initialization
    
    /// Create a new pulse system view
    /// - Parameters:
    ///   - effects: Initial effects to display
    ///   - maxEffects: Maximum number of simultaneous effects
    public init(effects: [PulseEffect] = [], maxEffects: Int = 5) {
        self.particles = PulseParticles(maxEffects: maxEffects)
        
        // Add initial effects
        effects.forEach { effect in
            particles.addEffect(effect)
        }
    }
    
    // MARK: - View Body
    
    public var body: some View {
        RealityView { content in
            // Add particle system root entity
            content.add(particles.rootEntity)
            showContent = true
        } update: { content in
            // Update is handled by timer
        }
        .onAppear {
            // Position effects when view appears
            layoutEffects()
        }
        .onReceive(timer) { time in
            // Update particle system each frame
            particles.update(currentTime: time.timeIntervalSinceReferenceDate)
        }
    }
    
    // MARK: - Public Methods
    
    /// Add a new effect to the view
    /// - Parameter effect: The effect to add
    /// - Returns: True if effect was added successfully
    @discardableResult
    public func addEffect(_ effect: PulseEffect) -> Bool {
        let result = particles.addEffect(effect)
        if result {
            layoutEffects() // Update layout when adding effect
        }
        return result
    }
    
    /// Remove an effect from the view
    /// - Parameter effect: The effect to remove
    public func removeEffect(_ effect: PulseEffect) {
        particles.removeEffect(effect)
        layoutEffects() // Update layout when removing effect
    }
    
    /// Remove all effects from the view
    public func removeAllEffects() {
        particles.removeAllEffects()
    }
    
    /// Get current performance metrics
    public var performanceMetrics: (activeEffects: Int, averageFrameRate: Double) {
        particles.performanceMetrics
    }
    
    /// Get detailed performance metrics including update times
    public var detailedMetrics: (
        activeEffects: Int,
        averageFrameRate: Double,
        averageUpdateTime: TimeInterval,
        peakUpdateTime: TimeInterval
    ) {
        particles.detailedMetrics
    }
    
    // MARK: - Private Methods
    
    /// Layout effects in 3D space
    private func layoutEffects() {
        // Get number of active effects
        let count = particles.performanceMetrics.activeEffects
        guard count > 0 else { return }
        
        // Calculate layout parameters
        let radius: Float = 2.0
        let angleStep = 2 * Float.pi / Float(count)
        
        // Create positions
        let positions = (0..<count).map { index in
            let angle = Float(index) * angleStep
            return SIMD3<Float>(
                radius * cos(angle),
                0,
                radius * sin(angle)
            )
        }
        
        // Apply positions to entities
        for (position, effect) in zip(positions, particles.activeEffects.values) {
            particles.setPosition(for: effect, position: position)
        }
    }
    
    /// Monitor performance and log warnings if needed
    private func monitorPerformance() {
        let metrics = detailedMetrics
        if metrics.averageFrameRate < 30 {
            print("⚠️ Low frame rate: \(Int(metrics.averageFrameRate)) FPS")
        }
        if metrics.averageUpdateTime > 0.016 { // More than 16ms per update
            print("⚠️ High update time: \(metrics.averageUpdateTime * 1000)ms")
        }
    }
} 