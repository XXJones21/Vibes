import RealityKit
import Foundation

/// A preset configuration for pulse particle effects
@available(visionOS 2.0, *)
public struct PulsePreset: Codable {
    // MARK: - Properties
    
    /// Name of the preset
    public let name: String
    
    /// Description of what this preset does
    public let description: String
    
    /// Base configuration for the effect
    public let configuration: PulseConfiguration
    
    /// Additional parameters specific to this preset
    public let parameters: [String: Float]
    
    // MARK: - Initialization
    
    /// Create a new pulse preset
    public init(
        name: String,
        description: String = "",
        configuration: PulseConfiguration,
        parameters: [String: Float] = [:]
    ) {
        self.name = name
        self.description = description
        self.configuration = configuration
        self.parameters = parameters
    }
    
    // MARK: - Parameter Access
    
    /// Get a parameter value, or return a default if not found
    public func parameter(_ key: String, defaultValue: Float = 0) -> Float {
        parameters[key] ?? defaultValue
    }
}

// MARK: - Standard Presets

@available(visionOS 2.0, *)
public extension PulsePreset {
    /// Gentle, floating particles
    static var fireflies: PulsePreset {
        PulsePreset(
            name: "Fireflies",
            description: "Gentle, floating particles that drift through space",
            configuration: PulseConfiguration(
                birthRate: 500,
                size: 0.05,
                lifetime: 6.0,
                speed: 0.3,
                emitterShape: .sphere,
                emitterSize: [5, 5, 5],
                acceleration: [0, 0.1, 0],
                color: .evolving(
                    start: SIMD4(1, 1, 1, 0.8),
                    end: SIMD4(1, 1, 1, 0.6)
                )
            ),
            parameters: [
                "pulseFrequency": 0.5,
                "pulseAmplitude": 0.3
            ]
        )
    }
    
    /// Swirling galaxy formation
    static var galaxy: PulsePreset {
        PulsePreset(
            name: "Galaxy",
            description: "Swirling particles forming a galaxy-like disk",
            configuration: PulseConfiguration(
                birthRate: 1000,
                size: 0.05,
                lifetime: 8.0,
                speed: 0.8,
                emitterShape: .sphere,
                emitterSize: [4, 0.1, 4],
                acceleration: [0, 0, 0],
                color: .evolving(
                    start: SIMD4(0.5, 0.8, 1.0, 0.8),
                    end: SIMD4(0.8, 0.5, 1.0, 0.6)
                )
            ),
            parameters: [
                "spinForce": 0.5,
                "centerAttraction": 0.3
            ]
        )
    }
} 