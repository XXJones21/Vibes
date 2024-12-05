import RealityKit
import SwiftUI
import CoreText

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
        case fireflyFloat
        case centerPull
        case textFormation
        case stableState
        case finalBurst
        case complete
    }
    
    // Animation durations
    private let fireflyDuration: TimeInterval = 4.0
    private let pullDuration: TimeInterval = 4.0
    private let textDuration: TimeInterval = 2.0
    private let stableDuration: TimeInterval = 2.0
    private let burstDuration: TimeInterval = 2.0
    
    private var textPaths: [CGPath] = []
    private var totalPathLength: CGFloat = 0
    
    deinit {
        currentAnimator?.invalidate()
        emissionTimer?.invalidate()
    }
    
    init() {
        let material = UnlitMaterial(color: .init(.purple.opacity(0.6)))
        let mesh = MeshResource.generateSphere(radius: 0.003)
        rootEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Generate text paths
        generateTextPaths()
        setupParticles()
    }
    
    private func generateTextPaths() {
        let text = "VIBES"
        let fontSize: CGFloat = 100  // Large size for better detail
        
        // Create font with specified name and size
        let font: CTFont? = CTFontCreateWithName("Helvetica-Bold" as CFString, fontSize, nil)
        guard let font = font else { return }
        
        var unichars = [UniChar](text.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        // Convert characters to glyphs
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        guard gotGlyphs else { return }
        
        var xOffset: CGFloat = 0
        
        // Generate path for each letter
        for glyph in glyphs {
            if let letterPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                // Get letter bounds
                var boundingBox = letterPath.boundingBox
                
                // Create transform to position letter
                var transform = CGAffineTransform(translationX: xOffset - boundingBox.origin.x, y: 0)
                
                // Apply transform to path
                if let transformedPath = letterPath.copy(using: &transform) {
                    textPaths.append(transformedPath)
                    totalPathLength += transformedPath.length
                }
                
                // Update offset for next letter
                xOffset += boundingBox.width + fontSize * 0.1 // 10% of fontSize for spacing
            }
        }
    }
    
    private func setupParticles() {
        for _ in 0..<particleCount {
            let particle = ModelEntity(
                mesh: MeshResource.generateSphere(radius: Float.random(in: 0.0025...0.0035)),
                materials: [generateRandomMaterial()]
            )
            particles.append(particle)
            rootEntity.addChild(particle)
            
            // Start particles in a more dispersed, firefly-like pattern
            let radius = Float.random(in: 4...8)
            let theta = Float.random(in: 0...2 * .pi)
            let phi = Float.random(in: 0...2 * .pi)
            
            particle.position = SIMD3<Float>(
                radius * sin(theta) * cos(phi),
                radius * sin(theta) * sin(phi),
                radius * cos(theta)
            )
            // Start particles visible but small
            particle.scale = SIMD3<Float>(repeating: 0.3)
        }
    }
    
    func startAnimation() {
        currentPhase = .fireflyFloat
        updateParticleDebugColor()
        animateFireflies()
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
    
    private func animateFireflies() {
        print("DEBUG: Starting firefly float animation")
        let startTime = Date()
        
        startNewAnimation { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = Float(min(1.0, elapsed / self.fireflyDuration))
            print("DEBUG: Firefly progress: \(Int(progress * 100))%")
            
            self.noiseOffset += 0.01
            
            // Update each particle with gentle, random movement
            self.updateParticlesInBatches { particle in
                let index = Float(self.particles.firstIndex(of: particle) ?? 0)
                
                // Create gentle, random movement using perlin noise
                let floatSpeed: Float = 0.3
                let floatAmplitude: Float = 0.5
                let individualOffset = index * 0.1
                
                let floatMotion = SIMD3<Float>(
                    sin(self.noiseOffset + individualOffset) * floatAmplitude,
                    cos(self.noiseOffset * 0.7 + individualOffset) * floatAmplitude,
                    sin(self.noiseOffset * 1.3 + individualOffset) * floatAmplitude
                )
                
                // Apply gentle movement
                particle.position += floatMotion * floatSpeed * 0.016
                
                // Subtle scale pulsing
                let scalePulse = 0.3 + sin(self.noiseOffset * 2 + individualOffset) * 0.1
                particle.scale = SIMD3<Float>(repeating: scalePulse)
            }
            
            if elapsed >= self.fireflyDuration {
                print("DEBUG: Firefly float complete, transitioning to center pull")
                timer.invalidate()
                self.currentPhase = .centerPull
                self.updateParticleDebugColor()
                self.animateCenterPull()
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
            
            // Exponential acceleration
            let accelerationCurve = pow(progress, 2.5)
            
            self.updateParticlesInBatches { particle in
                // Calculate direction to center
                let directionToCenter = -particle.position
                let distance = length(directionToCenter)
                
                if distance > 0.01 {  // Prevent division by zero
                    // Base pull force increases with progress
                    let basePullForce = 0.5 + (accelerationCurve * 2.0)
                    
                    // Gravitational effect: force increases as particles get closer
                    let gravitationalEffect = 1.0 + (1.0 - min(distance, 4.0) / 4.0) * accelerationCurve * 2.0
                    
                    // Calculate final force with direction
                    let pullForce = normalize(directionToCenter) * basePullForce * gravitationalEffect
                    
                    // Add some spiral motion
                    let spiralStrength = 0.5 * (1.0 - accelerationCurve)  // Spiral decreases as pull increases
                    let spiral = SIMD3<Float>(
                        -particle.position.y,
                        particle.position.x,
                        0
                    ) * spiralStrength
                    
                    // Apply forces
                    particle.position += (pullForce + normalize(spiral)) * 0.016
                    
                    // Scale particles slightly based on their speed toward center
                    let speedScale = 0.3 + (gravitationalEffect * 0.1)
                    particle.scale = SIMD3<Float>(repeating: speedScale)
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
        guard !textPaths.isEmpty else { return .zero }
        
        // Calculate which path and position along path
        let particlePosition = CGFloat(index) / CGFloat(particleCount) * totalPathLength
        var currentLength: CGFloat = 0
        
        for path in textPaths {
            let pathLength = path.length
            if currentLength + pathLength > particlePosition {
                // This is the path our particle belongs on
                let localPosition = particlePosition - currentLength
                let point = path.point(at: localPosition / pathLength)
                
                // Scale down the coordinates (since we used a large fontSize)
                let scale: Float = 0.01  // Adjust this to change overall text size
                return SIMD3<Float>(
                    Float(point.x) * scale,
                    Float(point.y) * scale,
                    0
                )
            }
            currentLength += pathLength
        }
        
        return .zero
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
        case .fireflyFloat: return .green
        case .centerPull: return .blue
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

// Extension to get path length and point at position
extension CGPath {
    var length: CGFloat {
        var length: CGFloat = 0
        applyWithBlock { element in
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint: break
            case .addLineToPoint:
                length += hypot(points[0].x - element.pointee.points[0].x,
                              points[0].y - element.pointee.points[0].y)
            case .addQuadCurveToPoint:
                // Approximate curve length
                length += 0.5 * hypot(points[0].x - points[1].x,
                                    points[0].y - points[1].y)
            case .addCurveToPoint:
                // Approximate curve length
                length += 0.5 * (hypot(points[0].x - points[1].x,
                                     points[0].y - points[1].y) +
                               hypot(points[1].x - points[2].x,
                                     points[1].y - points[2].y))
            case .closeSubpath: break
            @unknown default: break
            }
        }
        return length
    }
    
    func point(at position: CGFloat) -> CGPoint {
        var currentLength: CGFloat = 0
        var result = CGPoint.zero
        var found = false
        
        applyWithBlock { element in
            if found { return }
            let points = element.pointee.points
            
            switch element.pointee.type {
            case .moveToPoint:
                result = points[0]
            case .addLineToPoint:
                let length = hypot(points[0].x - result.x,
                                 points[0].y - result.y)
                if currentLength + length > position {
                    let t = (position - currentLength) / length
                    result = CGPoint(
                        x: result.x + (points[0].x - result.x) * t,
                        y: result.y + (points[0].y - result.y) * t
                    )
                    found = true
                } else {
                    currentLength += length
                    result = points[0]
                }
            case .addQuadCurveToPoint, .addCurveToPoint:
                // For curves, we'll use linear interpolation as an approximation
                let length = 0.5 * hypot(points[0].x - points[1].x,
                                       points[0].y - points[1].y)
                if currentLength + length > position {
                    let t = (position - currentLength) / length
                    result = CGPoint(
                        x: result.x + (points[1].x - result.x) * t,
                        y: result.y + (points[1].y - result.y) * t
                    )
                    found = true
                } else {
                    currentLength += length
                    result = points[1]
                }
            case .closeSubpath: break
            @unknown default: break
            }
        }
        return result
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
