import RealityKit
import Foundation
import QuartzCore
import RealityFoundation

/// A RealityKit System that manages aether particle emission and lifecycle
@available(visionOS 2.0, *)
public class AetherSystem: System {
    /// Query to find all particle emitters
    private static let emitterQuery = EntityQuery(where: .has(AetherEmitterComponent.self))
    
    /// Query to find all particles
    private static let particleQuery = EntityQuery(where: .has(AetherParticleComponent.self))
    
    /// Reusable particle entity for performance
    private var particlePrototype: Entity
    
    /// Last update timestamp for delta time calculation
    private var lastUpdateTime: TimeInterval = 0
    
    /// Rainbow color palette for random colors
    private let rainbowHues: [Float] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    
    /// System dependencies
    public static var dependencies: [SystemDependency] {
        // We don't need specific system dependencies for now
        []
    }
    
    /// Initialize the system
    public required init(scene: Scene) {
        // Create a prototype particle entity for reuse
        particlePrototype = Entity()
        
        // Add a model component for visualization
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .white)
        material.metallic = .init(floatLiteral: 0.0)
        material.roughness = .init(floatLiteral: 1.0)
        
        let mesh = MeshResource.generateSphere(radius: 0.02)
        let modelComponent = ModelComponent(mesh: mesh, materials: [material])
        particlePrototype.components[ModelComponent.self] = modelComponent
    }
    
    /// Update the system - called every frame
    public func update(context: SceneUpdateContext) {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        // Update existing particles
        for particleEntity in context.entities(matching: Self.particleQuery, updatingSystemWhen: .rendering) {
            guard var particle = particleEntity.components[AetherParticleComponent.self] else { continue }
            
            // Check if particle should die
            let age = currentTime - particle.birthTime
            if age >= Double(particle.lifetime) {
                particleEntity.removeFromParent()
                continue
            }
            
            // Update particle position
            particleEntity.position += particle.velocity * Float(deltaTime)
            
            // Update particle color based on age
            if var model = particleEntity.components[ModelComponent.self] {
                let progress = Float(age / Double(particle.lifetime))
                let color = interpolateColor(start: particle.startColor, end: particle.endColor, progress: progress)
                
                var material = PhysicallyBasedMaterial()
                material.baseColor = .init(tint: SimpleMaterial.Color(
                    red: Double(color.red),
                    green: Double(color.green),
                    blue: Double(color.blue),
                    alpha: Double(color.alpha)
                ))
                model.materials = [material]
                particleEntity.components[ModelComponent.self] = model
            }
            
            // Update velocity with acceleration from emitter
            if let emitter = findEmitterFor(particle: particleEntity, in: context.scene) {
                particle.velocity += emitter.acceleration * Float(deltaTime)
            }
            
            particleEntity.components[AetherParticleComponent.self] = particle
        }
        
        // Emit new particles
        for emitterEntity in context.entities(matching: Self.emitterQuery, updatingSystemWhen: .rendering) {
            guard let emitter = emitterEntity.components[AetherEmitterComponent.self] else { continue }
            
            if !emitter.isEmitting { continue }
            
            // Calculate how many particles to emit this frame
            let particlesToEmit = Int(emitter.birthRate * Float(deltaTime))
            
            for _ in 0..<particlesToEmit {
                // Create new particle by cloning prototype
                let particle = particlePrototype.clone(recursive: true)
                
                // Set initial position based on emitter shape
                let initialPosition = generatePosition(for: emitter)
                particle.position = emitterEntity.position + initialPosition
                particle.scale = emitter.scale
                
                // Generate colors based on config
                let (startColor, endColor) = generateColors(from: emitter.colorConfig)
                
                // Add particle component with initial properties
                let particleComponent = AetherParticleComponent(
                    birthTime: currentTime,
                    lifetime: emitter.lifetime,
                    velocity: generateVelocity(for: emitter, at: initialPosition),
                    startColor: startColor,
                    endColor: endColor
                )
                particle.components[AetherParticleComponent.self] = particleComponent
                
                // Set initial material color
                if var model = particle.components[ModelComponent.self] {
                    var material = PhysicallyBasedMaterial()
                    material.baseColor = .init(tint: SimpleMaterial.Color(
                        red: Double(startColor.red),
                        green: Double(startColor.green),
                        blue: Double(startColor.blue),
                        alpha: Double(startColor.alpha)
                    ))
                    model.materials = [material]
                    particle.components[ModelComponent.self] = model
                }
                
                // Add to scene
                emitterEntity.addChild(particle)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func generatePosition(for emitter: AetherEmitterComponent) -> SIMD3<Float> {
        switch emitter.shape {
        case .point:
            return .zero
            
        case .sphere:
            let radius = emitter.emitterSize.x / 2
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...(.pi))
            return [
                radius * sin(phi) * cos(theta),
                radius * sin(phi) * sin(theta),
                radius * cos(phi)
            ]
            
        case .plane:
            return [
                Float.random(in: -emitter.emitterSize.x/2...emitter.emitterSize.x/2),
                0,
                Float.random(in: -emitter.emitterSize.z/2...emitter.emitterSize.z/2)
            ]
        }
    }
    
    private func generateVelocity(for emitter: AetherEmitterComponent, at position: SIMD3<Float>) -> SIMD3<Float> {
        switch emitter.shape {
        case .point:
            let angle = Float.random(in: 0...(2 * .pi))
            return [
                cos(angle) * emitter.speed,
                sin(angle) * emitter.speed,
                Float.random(in: -0.5...0.5) * emitter.speed
            ]
            
        case .sphere:
            let direction = normalize(position)
            return direction * emitter.speed
            
        case .plane:
            return [0, -emitter.speed, 0] // Downward for rain effect
        }
    }
    
    private func generateColors(from config: AetherEmitterComponent.ColorConfig) -> (AetherEmitterComponent.ColorConfig.Color, AetherEmitterComponent.ColorConfig.Color) {
        switch config {
        case .constant(let color):
            return (color, color)
            
        case .evolving(let start, let end):
            return (start, end)
            
        case .rainbow:
            let hue = rainbowHues.randomElement() ?? 0
            let color = hsv2rgb(h: hue, s: 1.0, v: 1.0)
            let startColor = AetherEmitterComponent.ColorConfig.Color(
                red: color.0, green: color.1, blue: color.2, alpha: 0.8
            )
            let endColor = AetherEmitterComponent.ColorConfig.Color(
                red: color.0, green: color.1, blue: color.2, alpha: 0.0
            )
            return (startColor, endColor)
        }
    }
    
    private func interpolateColor(
        start: AetherEmitterComponent.ColorConfig.Color,
        end: AetherEmitterComponent.ColorConfig.Color,
        progress: Float
    ) -> AetherEmitterComponent.ColorConfig.Color {
        AetherEmitterComponent.ColorConfig.Color(
            red: start.red + (end.red - start.red) * progress,
            green: start.green + (end.green - start.green) * progress,
            blue: start.blue + (end.blue - start.blue) * progress,
            alpha: start.alpha + (end.alpha - start.alpha) * progress
        )
    }
    
    private func findEmitterFor(particle: Entity, in scene: Scene) -> AetherEmitterComponent? {
        for emitterEntity in scene.performQuery(Self.emitterQuery) {
            if let emitter = emitterEntity.components[AetherEmitterComponent.self],
               emitter.bounds.contains(particle.position - emitterEntity.position) {
                return emitter
            }
        }
        return nil
    }
    
    private func hsv2rgb(h: Float, s: Float, v: Float) -> (Float, Float, Float) {
        let c = v * s
        let x = c * (1 - abs(fmod(h * 6, 2) - 1))
        let m = v - c
        
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0
        
        switch h * 6 {
        case 0..<1:
            r = c; g = x; b = 0
        case 1..<2:
            r = x; g = c; b = 0
        case 2..<3:
            r = 0; g = c; b = x
        case 3..<4:
            r = 0; g = x; b = c
        case 4..<5:
            r = x; g = 0; b = c
        case 5..<6:
            r = c; g = 0; b = x
        default:
            break
        }
        
        return (r + m, g + m, b + m)
    }
} 