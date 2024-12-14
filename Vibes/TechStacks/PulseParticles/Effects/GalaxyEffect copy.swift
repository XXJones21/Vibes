import RealityKit
import SwiftUI

/// A particle effect that creates a swirling galaxy formation
@available(visionOS 2.0, *)
public class GalaxyEffect: PulseEffect {
    // MARK: - Properties
    
    public private(set) var state: PulseEffectState = .inactive
    public private(set) var staticProperties: PulseStaticProperties
    public var dynamicProperties: PulseDynamicProperties
    public var isDirty: Bool = true
    public var currentParticleSystem: ParticleEmitterComponent?
    
    /// Parameters for galaxy behavior
    private let spinForce: Float
    private let centerAttraction: Float
    private var currentTime: TimeInterval = 0
    
    // MARK: - Initialization
    
    public init(preset: PulsePreset = .galaxy) {
        let configuration = preset.configuration
        self.staticProperties = PulseStaticProperties(configuration: configuration)
        self.dynamicProperties = PulseDynamicProperties(configuration: configuration)
        self.spinForce = preset.parameter("spinForce", defaultValue: 0.5)
        self.centerAttraction = preset.parameter("centerAttraction", defaultValue: 0.3)
    }
    
    // MARK: - PulseEffect
    
    public func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float) {
        currentTime += Double(deltaTime)
        
        // Calculate spiral motion
        let time = Float(currentTime)
        let spiralX = cos(time * spinForce) * centerAttraction
        let spiralZ = sin(time * spinForce) * centerAttraction
        
        // Update acceleration for spiral motion
        var acceleration = dynamicProperties.acceleration
        acceleration.x = spiralX
        acceleration.z = spiralZ
        
        // Apply dynamic updates
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = dynamicProperties.color.realityKitColor
        particleSystem.mainEmitter.acceleration = .init(acceleration)
        
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