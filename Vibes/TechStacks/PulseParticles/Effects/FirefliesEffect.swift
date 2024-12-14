import RealityKit
import SwiftUI
import Foundation

/// A particle effect that creates floating, glowing particles reminiscent of fireflies
@available(visionOS 2.0, *)
public class FirefliesEffect: PulseEffect {
    // MARK: - Properties
    
    public private(set) var state: PulseEffectState = .inactive
    public private(set) var staticProperties: PulseStaticProperties
    public var dynamicProperties: PulseDynamicProperties
    public var isDirty: Bool = true
    public var currentParticleSystem: ParticleEmitterComponent?
    
    /// Parameters for glow effect
    private let pulseFrequency: Float
    private let pulseAmplitude: Float
    private var currentTime: TimeInterval = 0
    
    // MARK: - Initialization
    
    public init(preset: PulsePreset = .fireflies) {
        let configuration = preset.configuration
        self.staticProperties = PulseStaticProperties(configuration: configuration)
        self.dynamicProperties = PulseDynamicProperties(configuration: configuration)
        self.pulseFrequency = preset.parameter("pulseFrequency", defaultValue: 0.5)
        self.pulseAmplitude = preset.parameter("pulseAmplitude", defaultValue: 0.3)
    }
    
    // MARK: - PulseEffect
    
    public func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float) {
        currentTime += Double(deltaTime)
        
        // Calculate glow effect
        let glowIntensity = 0.8 + sin(Float(currentTime) * pulseFrequency) * pulseAmplitude
        
        // Update color with glow
        let color: PulseColor
        switch dynamicProperties.color {
        case .single(let r, let g, let b, let a):
            color = .single(red: r, green: g, blue: b, alpha: a * glowIntensity)
        case .evolving(let start, let end):
            let startWithGlow = SIMD4<Float>(start.x, start.y, start.z, start.w * glowIntensity)
            let endWithGlow = SIMD4<Float>(end.x, end.y, end.z, end.w * glowIntensity)
            color = .evolving(start: startWithGlow, end: endWithGlow)
        }
        
        // Apply dynamic updates
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = color.realityKitColor
        particleSystem.mainEmitter.acceleration = .init(dynamicProperties.acceleration)
        
        // Update state if needed
        switch state {
        case .inactive:
            state = .active
        case .active:
            break // Continue normal updates
        case .transitioning(let progress):
            if progress >= 1.0 {
                state = .active
            }
        case .completed:
            break
        }
    }
} 