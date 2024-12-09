import RealityKit
import Foundation

/// Shared physics calculations for particle effects
@available(visionOS 2.0, *)
enum AetherPhysics {
    // MARK: - Wave Effects
    static func wave(at time: TimeInterval, 
                    amplitude: Float = 1.0, 
                    frequency: Float = 1.0) -> SIMD3<Float> {
        SIMD3<Float>(
            cos(Float(time) * frequency) * amplitude,
            sin(Float(time) * frequency) * amplitude,
            0
        )
    }
    
    // MARK: - Swirl Effects
    static func swirl(at time: TimeInterval, 
                     intensity: Float, 
                     radius: Float = 1.0) -> SIMD3<Float> {
        let angle = Float(time)
        return SIMD3<Float>(
            cos(angle) * intensity * radius,
            sin(angle) * intensity * radius,
            0
        )
    }
    
    // MARK: - Attraction Effects
    static func centerAttraction(from position: SIMD3<Float>, 
                               to center: SIMD3<Float>, 
                               strength: Float) -> SIMD3<Float> {
        let direction = center - position
        return direction * strength
    }
    
    // MARK: - Spiral Effects
    static func spiral(at time: TimeInterval,
                      intensity: Float,
                      inwardPull: Float = 0.5) -> SIMD3<Float> {
        let baseSwirl = swirl(at: time, intensity: intensity)
        let inward = SIMD3<Float>(0, -inwardPull * intensity, 0)
        return baseSwirl + inward
    }
} 