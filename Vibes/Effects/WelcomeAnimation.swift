import RealityKit
import SwiftUI

@available(visionOS 2.0, *)
class WelcomeAnimation: ObservableObject {
    internal var rootEntity: ModelEntity
    private var particles: [ModelEntity] = []
    private var emissionTimer: Timer?
    private let particleCount = 500
    @Published private(set) var currentPhase: AnimationPhase = .initial {
        didSet {
            print("Animation phase changed: \(oldValue) -> \(currentPhase)")
        }
    }
    private var noiseOffset: Float = 0
    private var currentAnimator: Timer?
    
    enum AnimationPhase {
        case initial
        case particleSpawn
        case globeFormation
        case centerPull
        case textFormation
        case stableState
        case finalBurst
        case complete
    }
    
    // Animation durations
    private let spawnDuration: TimeInterval = 1.0
    private let globeDuration: TimeInterval = 3.0
    private let pullDuration: TimeInterval = 1.0
    private let textDuration: TimeInterval = 2.0
    private let stableDuration: TimeInterval = 2.0
    private let burstDuration: TimeInterval = 2.0
    
    deinit {
        currentAnimator?.invalidate()
        emissionTimer?.invalidate()
    }
    
    init() {
        let material = UnlitMaterial(color: .init(.purple.opacity(0.6)))
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
    
    func startAnimation() {
        currentPhase = .particleSpawn
        updateParticleDebugColor()
        animateParticleSpawn()
    }
    
    private func startNewAnimation(_ block: @escaping (Timer) -> Void) {
        currentAnimator?.invalidate()
        currentAnimator = Timer.scheduledTimer(withTimeInterval: 1/30, repeats: true, block: block)
        currentAnimator?.fire()
    }
    
    private func updateParticlesInBatches(_ update: (ModelEntity) -> Void) {
        let batchSize = 50
        for batchStart in stride(from: 0, to: particles.count, by: batchSize) {
            let endIndex = min(batchStart + batchSize, particles.count)
            for index in batchStart..<endIndex {
                update(particles[index])
            }
            Thread.sleep(forTimeInterval: 0.001)
        }
    }
    
    private func animateParticleSpawn() {
        print("DEBUG: Starting particle spawn animation")
        let startTime = Date()
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.spawnDuration))
            print("DEBUG: Spawn progress: \(Int(progress * 100))%")
            
            self.updateParticlesInBatches { particle in
                particle.scale = SIMD3<Float>(repeating: progress * 0.3)
            }
            
            if elapsed >= self.spawnDuration {
                print("DEBUG: Spawn complete, transitioning to globe formation")
                timer.invalidate()
                self.currentPhase = .globeFormation
                self.updateParticleDebugColor()
                self.animateGlobeFormation()
            }
        }
    }
    
    private func updateParticlePosition(_ particle: ModelEntity, index: Int, progress: Float, globeRadius: Float) {
        let floatSpeed: Float = 0.5
        let floatAmplitude: Float = 0.1
        let individualOffset = Float(index) * 0.1
        
        let floatMotion = SIMD3<Float>(
            sin(noiseOffset + individualOffset) * floatAmplitude,
            cos(noiseOffset * 0.7 + individualOffset) * floatAmplitude,
            sin(noiseOffset * 1.3 + individualOffset) * floatAmplitude
        )
        
        let theta = Float(index) / Float(particleCount) * 2 * .pi
        let phi = acos(2 * Float(index) / Float(particleCount) - 1)
        let targetPosition = SIMD3<Float>(
            globeRadius * sin(phi) * cos(theta),
            globeRadius * sin(phi) * sin(theta),
            globeRadius * cos(phi)
        )
        
        let currentPos = particle.position
        particle.position = currentPos + (targetPosition - currentPos + floatMotion) * floatSpeed * progress
    }
    
    private func updateParticleAppearance(_ particle: ModelEntity, progress: Float) {
        let newMaterial = interpolateColors(progress: progress)
        particle.model?.materials = [newMaterial]
        particle.scale = SIMD3<Float>(repeating: 0.3 + progress * 0.7) // Start from spawn scale and grow
    }
    
    private func animateGlobeFormation() {
        print("DEBUG: Starting globe formation animation")
        currentPhase = .globeFormation
        updateParticleDebugColor()
        let startTime = Date()
        let globeRadius: Float = 2.0
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.globeDuration))
            print("DEBUG: Globe formation progress: \(Int(progress * 100))%")
            
            self.noiseOffset += 0.01
            
            self.updateParticlesInBatches { particle in
                if let index = self.particles.firstIndex(of: particle) {
                    self.updateParticlePosition(particle, index: index, progress: progress, globeRadius: globeRadius)
                    self.updateParticleAppearance(particle, progress: progress)
                }
            }
            
            if elapsed >= self.globeDuration {
                print("DEBUG: Globe formation complete, transitioning to center pull")
                timer.invalidate()
                self.currentPhase = .centerPull
                self.updateParticleDebugColor()
                self.animateCenterPull()
            }
        }
    }
    
    private func animateCenterPull() {
        print("DEBUG: Starting center pull animation")
        currentPhase = .centerPull
        updateParticleDebugColor()
        let startTime = Date()
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.pullDuration))
            print("DEBUG: Center pull progress: \(Int(progress * 100))%")
            
            self.noiseOffset += 0.02
            
            self.updateParticlesInBatches { particle in
                if let index = self.particles.firstIndex(of: particle) {
                    let directionToCenter = -particle.position
                    let distance = length(directionToCenter)
                    
                    // Add swirl effect
                    let swirl = SIMD3<Float>(
                        -particle.position.y,
                        particle.position.x,
                        particle.position.z
                    ) * 0.5
                    
                    let pullForce = normalize(directionToCenter) * (2.0 - distance) * progress
                    let swirlForce = normalize(swirl) * 0.3 * (1.0 - progress)
                    
                    particle.position += (pullForce + swirlForce) * 0.05
                }
            }
            
            if elapsed >= self.pullDuration {
                print("DEBUG: Center pull complete, transitioning to text formation")
                timer.invalidate()
                self.currentPhase = .textFormation
                self.updateParticleDebugColor()
                self.animateTextFormation()
            }
        }
    }
    
    private func animateTextFormation() {
        print("DEBUG: Starting text formation animation")
        currentPhase = .textFormation
        updateParticleDebugColor()
        let startTime = Date()
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.textDuration))
            print("DEBUG: Text formation progress: \(Int(progress * 100))%")
            
            self.noiseOffset += 0.01
            
            self.updateParticlesInBatches { particle in
                if let index = self.particles.firstIndex(of: particle) {
                    let textPosition = self.getTextPosition(forIndex: index)
                    let oscillation = sin(self.noiseOffset + Float(index) * 0.1) * 0.02
                    
                    let targetPos = textPosition + SIMD3<Float>(0, oscillation, 0)
                    particle.position = mix(particle.position, targetPos, t: progress)
                }
            }
            
            if elapsed >= self.textDuration {
                print("DEBUG: Text formation complete, transitioning to stable state")
                timer.invalidate()
                self.currentPhase = .stableState
                self.updateParticleDebugColor()
                self.animateStableState()
            }
        }
    }
    
    private func animateStableState() {
        print("DEBUG: Starting stable state animation")
        let startTime = Date()
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.stableDuration))
            print("DEBUG: Stable state progress: \(Int(progress * 100))%")
            
            self.noiseOffset += 0.005
            
            self.updateParticlesInBatches { particle in
                if let index = self.particles.firstIndex(of: particle) {
                    let oscillation = sin(self.noiseOffset + Float(index) * 0.1) * 0.01
                    particle.position.y += oscillation
                    
                    // Pulse colors
                    let colorPulse = (sin(self.noiseOffset * 2) + 1) * 0.5
                    let newMaterial = self.interpolateColors(progress: colorPulse)
                    particle.model?.materials = [newMaterial]
                }
            }
            
            if elapsed >= self.stableDuration {
                print("DEBUG: Stable state complete, transitioning to final burst")
                timer.invalidate()
                self.currentPhase = .finalBurst
                self.updateParticleDebugColor()
                self.animateFinalBurst()
            }
        }
    }
    
    private func animateFinalBurst() {
        print("DEBUG: Starting final burst animation")
        let startTime = Date()
        
        // Calculate burst velocities
        var velocities: [SIMD3<Float>] = []
        for particle in particles {
            let directionFromCenter = normalize(particle.position)
            let speed = Float.random(in: 2.0...4.0)
            velocities.append(directionFromCenter * speed)
        }
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.burstDuration))
            print("DEBUG: Final burst progress: \(Int(progress * 100))%")
            
            self.updateParticlesInBatches { particle in
                if let index = self.particles.firstIndex(of: particle) {
                    particle.position += velocities[index] * 0.016
                    
                    // Fade out
                    if let material = particle.model?.materials.first as? UnlitMaterial {
                        let newMaterial = UnlitMaterial(
                            color: material.color.tint.withAlphaComponent(1.0 - CGFloat(progress))
                        )
                        particle.model?.materials = [newMaterial]
                    }
                }
            }
            
            if elapsed >= self.burstDuration {
                print("DEBUG: Final burst complete, animation sequence finished")
                timer.invalidate()
                self.currentPhase = .complete
                self.updateParticleDebugColor()
            }
        }
    }
    
    private func getTextPosition(forIndex index: Int) -> SIMD3<Float> {
        let letterHeight: Float = 0.5
        let letterSpacing: Float = 0.4
        let startX: Float = -1.0
        
        let points: [SIMD3<Float>] = [
            // V
            SIMD3<Float>(startX, letterHeight/2, 0),
            SIMD3<Float>(startX + 0.2, -letterHeight/2, 0),
            SIMD3<Float>(startX + 0.4, letterHeight/2, 0),
            
            // I
            SIMD3<Float>(startX + letterSpacing, letterHeight/2, 0),
            SIMD3<Float>(startX + letterSpacing, -letterHeight/2, 0),
            
            // B
            SIMD3<Float>(startX + letterSpacing * 2, letterHeight/2, 0),
            SIMD3<Float>(startX + letterSpacing * 2, -letterHeight/2, 0),
            SIMD3<Float>(startX + letterSpacing * 2.5, 0, 0),
            
            // E
            SIMD3<Float>(startX + letterSpacing * 3, letterHeight/2, 0),
            SIMD3<Float>(startX + letterSpacing * 3, 0, 0),
            SIMD3<Float>(startX + letterSpacing * 3, -letterHeight/2, 0),
            
            // S
            SIMD3<Float>(startX + letterSpacing * 4, letterHeight/2, 0),
            SIMD3<Float>(startX + letterSpacing * 4.2, 0, 0),
            SIMD3<Float>(startX + letterSpacing * 4.4, -letterHeight/2, 0)
        ]
        
        let pathIndex = (index * points.count) / particleCount
        return points[pathIndex]
    }
    
    private func generateRandomMaterial() -> UnlitMaterial {
        let colors: [Color] = [.purple, .blue]
        let color = colors.randomElement()!
        return UnlitMaterial(color: .init(color))
    }
    
    private func interpolateColors(progress: Float) -> UnlitMaterial {
        let colors: [Color] = [.purple, .blue]
        let index = Int(progress * Float(colors.count - 1))
        let color = colors[index]
        return UnlitMaterial(color: .init(color))
    }
    
    private func getDebugColorForPhase(_ phase: AnimationPhase) -> UIColor {
        switch phase {
        case .initial: return .gray
        case .particleSpawn: return .green
        case .globeFormation: return .blue
        case .centerPull: return .yellow
        case .textFormation: return .orange
        case .stableState: return .purple
        case .finalBurst: return .red
        case .complete: return .white
        }
    }

    private func updateParticleDebugColor() {
        let debugColor = getDebugColorForPhase(currentPhase)
        let material = UnlitMaterial(color: debugColor.withAlphaComponent(0.6))
        updateParticlesInBatches { particle in
            particle.model?.materials = [material]
        }
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