import RealityKit

@available(visionOS 2.0, *)
public extension ParticleEmitterComponent.ParticleEmitter {
    typealias ParticleColor = RealityKit.ParticleEmitterComponent.ParticleEmitter.ParticleColor
    typealias Color = RealityKit.ParticleEmitterComponent.ParticleEmitter.Color
    
    enum ColorMode {
        case constant(Color)
        case evolving(start: Color, end: Color)
        case multiple([Color])
    }
}

@available(visionOS 2.0, *)
public extension ParticleEmitterComponent {
    typealias EmitterShape = RealityKit.ParticleEmitterComponent.EmitterShape
    
    enum Shape {
        case sphere
        case point
        case plane
    }
} 