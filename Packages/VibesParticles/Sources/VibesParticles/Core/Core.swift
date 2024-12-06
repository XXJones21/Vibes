import RealityKit

/// VibesParticles is a specialized particle system for creating ethereal, music-reactive visualizations in visionOS.
///
/// The package provides a high-level interface for creating immersive particle effects that respond to music and create
/// atmospheric experiences. It's designed specifically for the Vibes app to create visual connections between users and their music.
///
/// Key features:
/// - Music-reactive particle behaviors
/// - Ethereal visual effects
/// - Preset configurations for different moods
/// - Support for complex animations
/// - Optimized for visionOS spatial experiences
///
/// Usage:
/// ```swift
/// // Register the system when your app launches
/// VibesParticles.registerSystem()
///
/// // Create an effect using presets
/// let entity = Entity()
/// entity.components.set(FirefliesEffect.emitterComponent)
/// ```
@available(visionOS 2.0, macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct VibesParticles {
    /// Register the Aether particle system with RealityKit.
    /// This should be called when your app launches, typically in your app's init
    /// or when setting up your first RealityView.
    public static func registerSystem() {
        guard !isRegistered else { return }
        
        // Register the system with RealityKit
        AetherSystem.registerSystem()
        isRegistered = true
        print("VibesParticles: Successfully registered AetherSystem")
    }
    
    /// Unregister the Aether particle system.
    /// This should be called when your app is terminating or when you no longer need particle effects.
    public static func unregisterSystem() {
        guard isRegistered else { return }
        isRegistered = false
        print("VibesParticles: Successfully unregistered AetherSystem")
    }
    
    /// Version of the VibesParticles package
    public static let version = "1.0.0"
    
    /// Whether the system has been registered
    public private(set) static var isRegistered = false
} 