import RealityKit

/// Handles registration of built-in particle effect presets
@available(visionOS 2.0, *)
enum AetherPresetRegistration {
    /// Register all built-in presets with the effects registry
    static func registerPresets(in registry: EffectsRegistry) {
        registry.register(AetherFirefliesEffect.self, name: "fireflies")
        registry.register(AetherGalaxyEffect.self, name: "galaxy")
    }
} 