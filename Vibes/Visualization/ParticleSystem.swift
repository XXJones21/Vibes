import RealityKit
import SwiftUI
import UIKit
import QuartzCore

public final class ParticleSystem: ObservableObject {
    private var rootEntity: Entity?
    private var particles: [ModelEntity] = []
    private var displayLink: CADisplayLink?
    private let maxParticles = 1000
    
    @Published public var currentGenre: String = "electronic"
    @Published public var currentStyle: String = "particles"
    @Published public var currentMood: String = "energetic"
    
    private var particleStates: [(position: SIMD3<Float>, velocity: SIMD3<Float>, color: Color, scale: Float, lifetime: Float)] = []
    
    public init() {
        setupParticleStates()
        startAnimation()
    }
    
    public func initialize(with rootEntity: Entity) {
        self.rootEntity = rootEntity
        setupParticles()
        // Position relative to user's space
        rootEntity.position = SIMD3<Float>(0, 1.6, -2) // Eye level, 2m away
    }
    
    private func setupParticles() {
        let meshVariants = [
            MeshResource.generateSphere(radius: 0.01),
            MeshResource.generateBox(size: 0.02),
            MeshResource.generateCone(height: 0.03, radius: 0.01)
        ]
        
        for i in 0..<maxParticles {
            let mesh = meshVariants[i % meshVariants.count]
            var material = UnlitMaterial()
            material.color = .init(tint: .white)
            let particle = ModelEntity(mesh: mesh, materials: [material])
            particle.isEnabled = false
            particles.append(particle)
            rootEntity?.addChild(particle)
        }
    }
    
    private func setupParticleStates() {
        particleStates = (0..<maxParticles).map { _ in
            (
                position: SIMD3<Float>(0, 0, 0),
                velocity: SIMD3<Float>(Float.random(in: -0.1...0.1),
                                     Float.random(in: -0.1...0.1),
                                     Float.random(in: -0.1...0.1)),
                color: .white,
                scale: Float.random(in: 0.5...1.5),
                lifetime: Float.random(in: 1.0...3.0)
            )
        }
    }
    
    private func startAnimation() {
        #if os(iOS) || os(visionOS)
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 120)
        displayLink?.add(to: .main, forMode: .default)
        #endif
    }
    
    @objc private func update() {
        updateParticles()
    }
    
    private func updateParticles() {
        guard let rootEntity = rootEntity else { return }
        
        for i in 0..<particleStates.count {
            var state = particleStates[i]
            let particle = particles[i]
            
            // Update state
            state.position += state.velocity
            state.lifetime -= 1.0 / 60.0
            
            // Reset particle if lifetime expired
            if state.lifetime <= 0 {
                state.position = SIMD3<Float>(0, 0, 0)
                state.velocity = SIMD3<Float>(Float.random(in: -0.1...0.1),
                                            Float.random(in: -0.1...0.1),
                                            Float.random(in: -0.1...0.1))
                state.lifetime = Float.random(in: 1.0...3.0)
                state.scale = Float.random(in: 0.5...1.5)
            }
            
            // Update particle entity
            particle.position = state.position
            particle.scale = .init(repeating: state.scale)
            if let material = particle.model?.materials.first as? UnlitMaterial {
                var updatedMaterial = material
                updatedMaterial.color = .init(tint: SimpleMaterial.Color(state.color))
                particle.model?.materials = [updatedMaterial]
            }
            particle.isEnabled = true
            
            particleStates[i] = state
        }
    }
    
    func updateParticleColors(_ color: Color) {
        for i in 0..<particleStates.count where i < particles.count {
            particleStates[i].color = color
            let particle = particles[i]
            if let material = particle.model?.materials.first as? UnlitMaterial {
                var updatedMaterial = material
                let components = UIColor(color).cgColor.components ?? [0, 0, 0, 1]
                let tintColor = SimpleMaterial.Color(
                    red: CGFloat(components[0]),
                    green: CGFloat(components[1]),
                    blue: CGFloat(components[2]),
                    alpha: CGFloat(components[3])
                )
                updatedMaterial.color = .init(tint: tintColor)
                particle.model?.materials = [updatedMaterial]
            }
        }
    }
    
    deinit {
        displayLink?.invalidate()
    }
} 