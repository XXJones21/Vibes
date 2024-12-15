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
                birthRate: 100,
                size: 0.03,
                lifetime: 3.0,
                speed: 0.1,
                emitterShape: .sphere,
                emitterSize: [0.5, 0.5, 0.5],
                acceleration: [0, 0.02, 0],
                color: .evolving(
                    start: SIMD4(1, 0.9, 0.4, 1.0),
                    end: SIMD4(1, 0.7, 0.2, 0.8)
                )
            ),
            parameters: [
                "pulseFrequency": 2.0,
                "pulseAmplitude": 0.5
            ]
        )
    }
    
    /// Swirling galaxy formation
    static var galaxy: PulsePreset {
        PulsePreset(
            name: "Galaxy",
            description: "Swirling particles forming a galaxy-like disk",
            configuration: PulseConfiguration(
                birthRate: 200,
                size: 0.02,
                lifetime: 3.0,
                speed: 0.2,
                emitterShape: .sphere,
                emitterSize: [0.8, 0.1, 0.8],
                acceleration: [0, -0.05, 0],
                color: .evolving(
                    start: SIMD4(0.8, 0.9, 1.0, 1.0),
                    end: SIMD4(0.9, 0.8, 1.0, 0.8)
                )
            ),
            parameters: [
                "spinForce": 0.8,
                "centerAttraction": 0.3
            ]
        )
    }
} 