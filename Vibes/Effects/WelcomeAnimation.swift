import RealityKit
import SwiftUI

@available(visionOS 2.0, *)
class WelcomeAnimation: ObservableObject {
    internal var rootEntity: ModelEntity
    private var particles: [ModelEntity] = []
    private var emissionTimer: Timer?
    private let particleCount = 1000
    @Published private(set) var currentPhase: AnimationPhase = .initial
    private var noiseOffset: Float = 0
    
    enum AnimationPhase {
        case initial
        case globeFormation
        case centerPull
        case textFormation
        case stable
        case burst
        case complete
    }
    
    init() {
        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = .systemPurple
        material.emissiveColor = .init(color: .systemPurple)
        material.emissiveIntensity = 2.0
        material.metallic = .init(floatLiteral: 0.0)
        
        let mesh = MeshResource.generateSphere(radius: 0.02)
        rootEntity = ModelEntity(mesh: mesh, materials: [material])
        setupParticles()
    }
    
    private func setupParticles() {
        for _ in 0..<particleCount {
            let particle = ModelEntity(
                mesh: MeshResource.generateSphere(radius: Float.random(in: 0.01...0.03)),
                materials: [generateRandomMaterial()]
            )
            particles.append(particle)
            rootEntity.addChild(particle)
            
            // Start particles at random positions far from center
            let radius = Float.random(in: 2...3)
            let theta = Float.random(in: 0...2 * .pi)
            let phi = Float.random(in: 0...2 * .pi)
            
            particle.position = SIMD3<Float>(
                radius * sin(theta) * cos(phi),
                radius * sin(theta) * sin(phi),
                radius * cos(theta)
            )
            particle.scale = .zero
        }
    }
    
    private func generateRandomMaterial() -> PhysicallyBasedMaterial {
        let colors: [(color: SimpleMaterial.Color, intensity: Float)] = [
            (.systemPurple, Float.random(in: 0.4...0.8)),
            (.systemBlue, Float.random(in: 0.4...0.8))
        ]
        let colorTuple = colors.randomElement()!
        
        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = colorTuple.color
        material.emissiveColor = .init(color: colorTuple.color)
        material.emissiveIntensity = colorTuple.intensity * 2.0
        material.metallic = .init(floatLiteral: 0.0)
        return material
    }
    
    private func interpolateColors(progress: Float) -> PhysicallyBasedMaterial {
        let colors: [SimpleMaterial.Color] = [.systemPurple, .systemBlue]
        let index = Int(progress * Float(colors.count - 1))
        let nextIndex = min(index + 1, colors.count - 1)
        let t = progress * Float(colors.count - 1) - Float(index)
        
        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = colors[index]
        material.emissiveColor = .init(color: colors[index])
        material.emissiveIntensity = 2.0 * (1.0 - t)
        material.metallic = .init(floatLiteral: 0.0)
        return material
    }
    
    private func updateParticleStates() {
        for (index, particle) in particles.enumerated() {
            let textPath = generateTextPath()
            let pathIndex = (index * textPath.count) / particles.count
            let basePosition = textPath[pathIndex]
            
            let oscillation = sin(Float(noiseOffset) + Float(index) * 0.1) * 0.02
            
            let noise = SimplexNoise.noise(
                x: Double(basePosition.x + noiseOffset),
                y: Double(basePosition.y + noiseOffset),
                z: Double(basePosition.z + noiseOffset)
            )
            
            let noiseVector = SIMD3<Float>(
                Float(noise) * 0.01,
                Float(noise) * 0.01 + oscillation,
                Float(noise) * 0.01
            )
            
            particle.position = basePosition + noiseVector
            
            let colorProgress = (sin(Float(noiseOffset) * 2 + Float(index) * 0.1) + 1) * 0.5
            particle.model?.materials = [interpolateColors(progress: colorProgress)]
        }
    }
    
    private func generateTextPath() -> [SIMD3<Float>] {
        let letterHeight: Float = 0.5
        let points: [SIMD3<Float>] = [
            // V
            SIMD3<Float>(-1.0, letterHeight/2, 0),
            SIMD3<Float>(-0.8, -letterHeight/2, 0),
            SIMD3<Float>(-0.6, letterHeight/2, 0),
            
            // I
            SIMD3<Float>(-0.4, letterHeight/2, 0),
            SIMD3<Float>(-0.4, -letterHeight/2, 0),
            
            // B
            SIMD3<Float>(-0.2, letterHeight/2, 0),
            SIMD3<Float>(-0.2, -letterHeight/2, 0),
            SIMD3<Float>(0.0, 0, 0),
            
            // E
            SIMD3<Float>(0.2, letterHeight/2, 0),
            SIMD3<Float>(0.2, 0, 0),
            SIMD3<Float>(0.2, -letterHeight/2, 0),
            
            // S
            SIMD3<Float>(0.6, letterHeight/2, 0),
            SIMD3<Float>(0.8, 0, 0),
            SIMD3<Float>(1.0, -letterHeight/2, 0)
        ]
        
        var smoothPath: [SIMD3<Float>] = []
        for i in 0..<points.count-1 {
            let start = points[i]
            let end = points[i+1]
            let steps = 10
            
            for step in 0...steps {
                let t = Float(step) / Float(steps)
                let point = start + (end - start) * t
                smoothPath.append(point)
            }
        }
        
        return smoothPath
    }
    
    func startAnimation() {
        currentPhase = .globeFormation
        animateGlobeFormation()
    }
    
    private func animateGlobeFormation() {
        let animator = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else { 
                timer.invalidate()
                return 
            }
            
            self.noiseOffset += 0.01
            
            for (index, particle) in self.particles.enumerated() {
                let radius: Float = 1.0
                let theta = Float(index) / Float(self.particleCount) * 2 * .pi
                let phi = acos(2 * Float(index) / Float(self.particleCount) - 1)
                
                let targetPosition = SIMD3<Float>(
                    radius * sin(phi) * cos(theta),
                    radius * sin(phi) * sin(theta),
                    radius * cos(phi)
                )
                
                let noise = SimplexNoise.noise(
                    x: Double(targetPosition.x + self.noiseOffset),
                    y: Double(targetPosition.y + self.noiseOffset),
                    z: Double(targetPosition.z + self.noiseOffset)
                )
                
                let noiseVector = SIMD3<Float>(repeating: Float(noise) * 0.1)
                let currentPos = particle.position
                let newPos = currentPos + (targetPosition + noiseVector - currentPos) * 0.05
                
                particle.position = newPos
                particle.scale = particle.scale + (SIMD3<Float>(repeating: 1) - particle.scale) * 0.1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                timer.invalidate()
                self.animateCenterPull()
            }
        }
        
        animator.fire()
    }
    
    private func animateCenterPull() {
        currentPhase = .centerPull
        
        let animator = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.noiseOffset += 0.02
            
            for particle in self.particles {
                let directionToCenter = -particle.position
                let distance = length(directionToCenter)
                
                let swirl = SIMD3<Float>(
                    -particle.position.y,
                    particle.position.x,
                    particle.position.z
                ) * 0.5
                
                let pullForce = normalize(directionToCenter) * (2.0 - distance)
                let swirlForce = normalize(swirl) * 0.3
                
                let noise = SimplexNoise.noise(
                    x: Double(particle.position.x + self.noiseOffset),
                    y: Double(particle.position.y + self.noiseOffset),
                    z: Double(particle.position.z + self.noiseOffset)
                )
                
                let noiseForce = SIMD3<Float>(repeating: Float(noise) * 0.1)
                let newPosition = particle.position + (pullForce + swirlForce + noiseForce) * 0.05
                particle.position = newPosition
                
                let scale = max(0.3, distance * 0.5)
                particle.scale = SIMD3<Float>(repeating: scale)
            }
            
            let averageDistance = self.particles.reduce(0.0) { $0 + length($1.position) } / Float(self.particles.count)
            
            if averageDistance < 0.2 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.animateTextFormation()
                }
            }
        }
        
        animator.fire()
    }
    
    private func animateTextFormation() {
        currentPhase = .textFormation
        let textPath = generateTextPath()
        
        for (index, particle) in particles.enumerated() {
            let pathIndex = (index * textPath.count) / particles.count
            particle.position = textPath[pathIndex]
        }
        
        let animator = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.noiseOffset += 0.01
            var allParticlesInPosition = true
            
            for (index, particle) in self.particles.enumerated() {
                let pathIndex = (index * textPath.count) / self.particles.count
                let targetPosition = textPath[pathIndex]
                
                let noise = SimplexNoise.noise(
                    x: Double(particle.position.x + self.noiseOffset),
                    y: Double(particle.position.y + self.noiseOffset),
                    z: Double(particle.position.z + self.noiseOffset)
                )
                
                let noiseVector = SIMD3<Float>(repeating: Float(noise) * 0.02)
                let direction = targetPosition - particle.position
                let distance = length(direction)
                
                if distance > 0.01 {
                    allParticlesInPosition = false
                    particle.position += normalize(direction) * 0.1 + noiseVector
                } else {
                    particle.position = targetPosition + noiseVector
                }
                
                let progress = Float(index) / Float(self.particles.count)
                particle.model?.materials = [interpolateColors(progress: progress)]
            }
            
            if allParticlesInPosition {
                timer.invalidate()
                self.animateStableState()
            }
        }
        
        animator.fire()
    }
    
    private func animateStableState() {
        currentPhase = .stable
        
        let animator = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.noiseOffset += 0.005
            self.updateParticleStates()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            animator.invalidate()
            self.animateBurst()
        }
        
        animator.fire()
    }
    
    private func animateBurst() {
        currentPhase = .burst
        
        var velocities: [SIMD3<Float>] = []
        for particle in particles {
            let directionFromCenter = normalize(particle.position)
            let speed = Float.random(in: 2.0...4.0)
            velocities.append(directionFromCenter * speed)
        }
        
        let animator = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.noiseOffset += 0.02
            var allParticlesGone = true
            
            for (index, particle) in self.particles.enumerated() {
                particle.position += velocities[index] * 0.016
                
                let noise = SimplexNoise.noise(
                    x: Double(particle.position.x + self.noiseOffset),
                    y: Double(particle.position.y + self.noiseOffset),
                    z: Double(particle.position.z + self.noiseOffset)
                )
                
                let drift = SIMD3<Float>(
                    Float(noise) * 0.1,
                    0.5,
                    Float(noise) * 0.1
                )
                
                particle.position += drift * 0.016
                
                if let material = particle.model?.materials.first as? PhysicallyBasedMaterial {
                    let fadeRate: Float = 0.02
                    let newEmissive = max(0, material.emissiveIntensity - fadeRate)
                    
                    if newEmissive > 0 {
                        allParticlesGone = false
                        var newMaterial = PhysicallyBasedMaterial()
                        newMaterial.baseColor.tint = material.baseColor.tint
                        newMaterial.emissiveColor = material.emissiveColor
                        newMaterial.emissiveIntensity = newEmissive
                        newMaterial.metallic = .init(floatLiteral: 0.0)
                        particle.model?.materials = [newMaterial]
                        
                        // Combine with scale effect for smoother fade
                        particle.scale = particle.scale * (1.0 - fadeRate)
                    }
                }
            }
            
            if allParticlesGone {
                timer.invalidate()
                self.currentPhase = .complete
            }
        }
        
        animator.fire()
    }
}

// MARK: - SwiftUI Integration
@available(visionOS 2.0, *)
struct WelcomeAnimationView: View {
    @StateObject private var animation = WelcomeAnimation()
    let onComplete: () -> Void
    
    var body: some View {
        RealityView { content in
            content.add(animation.rootEntity)
        }
        .onAppear {
            animation.startAnimation()
        }
        .onChange(of: animation.currentPhase) { _, phase in
            if phase == .complete {
                onComplete()
            }
        }
    }
}

// MARK: - Noise Generation
private enum SimplexNoise {
    static func noise(x: Double, y: Double, z: Double) -> Double {
        let xi = floor(x)
        let yi = floor(y)
        let zi = floor(z)
        
        let xf = x - xi
        let yf = y - yi
        let zf = z - zi
        
        return sin(xf) * cos(yf) * sin(zf) * 0.5 + 0.5
    }
} 