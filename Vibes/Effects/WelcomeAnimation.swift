import SwiftUI
import RealityKit
import VibesParticles

/// Creates an immersive welcome animation using ethereal particle effects
@available(visionOS 2.0, *)
public class WelcomeLetterAnimation: ObservableObject {
    // Root entity that will host all particle systems
    public private(set) var rootEntity = Entity()
    
    // Main particle system for initial phases
    private var mainSystem: AetherParticles
    
    // Letter particle systems for split phase
    private var letterSystems: [AetherParticles] = []
    
    // Animation phase tracking
    @Published public private(set) var currentPhase: AnimationPhase = .initial {
        didSet {
            print("Animation phase changed: \(oldValue) -> \(currentPhase)")
        }
    }
    
    // Animation phases
    public enum AnimationPhase {
        case initial
        case fireflyFloat
        case centerPull
        case galaxyForm
        case galaxySplit
        case stableState
        case finalBurst
        case complete
    }
    
    // Animation durations
    private let fireflyDuration: TimeInterval = 4.0
    private let pullDuration: TimeInterval = 4.0
    private let galaxyDuration: TimeInterval = 3.0
    private let splitDuration: TimeInterval = 3.0
    private let stableDuration: TimeInterval = 2.0
    private let burstDuration: TimeInterval = 2.0
    
    public init() {
        // Initialize main particle system with firefly preset
        mainSystem = AetherParticles(configuration: AetherParticles.ParticlePreset.fireflies.configuration)
        rootEntity.addChild(mainSystem.rootEntity)
        
        // Create letter systems (initially hidden)
        for i in 0..<5 {
            let system = AetherParticles.forLetterPosition(i)
            letterSystems.append(system)
            rootEntity.addChild(system.rootEntity)
        }
        
        // Calculate visual bounds for proper positioning
        let bounds = rootEntity.visualBounds(relativeTo: nil)
        
        // Position in space - adjust based on visual bounds
        rootEntity.position = [
            -bounds.min.x,  // Center horizontally
            1.6 - bounds.min.y,  // Eye level, accounting for bounds
            -2.0 - bounds.min.z  // 2 meters away, accounting for bounds
        ]
    }
    
    public func startAnimation() {
        // Start the animation sequence
        currentPhase = .fireflyFloat
        updateParticlesForPhase(.fireflyFloat)
        
        // Schedule phase transitions
        DispatchQueue.main.asyncAfter(deadline: .now() + fireflyDuration) { [weak self] in
            self?.transitionToPhase(.centerPull)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (self?.pullDuration ?? 4.0)) { [weak self] in
                self?.transitionToPhase(.galaxyForm)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + (self?.galaxyDuration ?? 3.0)) { [weak self] in
                    self?.transitionToPhase(.galaxySplit)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + (self?.splitDuration ?? 3.0)) { [weak self] in
                        self?.transitionToPhase(.stableState)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + (self?.stableDuration ?? 2.0)) { [weak self] in
                            self?.transitionToPhase(.finalBurst)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + (self?.burstDuration ?? 2.0)) { [weak self] in
                                self?.transitionToPhase(.complete)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func transitionToPhase(_ phase: AnimationPhase) {
        currentPhase = phase
        updateParticlesForPhase(phase)
    }
    
    private func updateParticlesForPhase(_ phase: AnimationPhase) {
        print("Updating particles for phase: \(phase)")
        switch phase {
        case .initial:
            print("Initial phase - stopping all systems")
            mainSystem.stop()
            letterSystems.forEach { $0.stop() }
            
        case .fireflyFloat:
            print("Firefly phase - starting main system with fireflies preset")
            mainSystem.update(with: AetherParticles.ParticlePreset.fireflies.configuration)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .centerPull:
            print("Center pull phase - updating configuration")
            let config = AetherParticles.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [2, 2, 2],
                birthRate: 100,
                colorConfig: AetherParticles.randomRainbowColor(),
                bounds: BoundingBox(min: [-5, -5, -5], max: [5, 5, 5]),
                acceleration: [0, -0.5, -2.0],
                speed: 0.5,
                lifetime: 3.0
            )
            mainSystem.update(with: config)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .galaxyForm:
            mainSystem.update(with: AetherParticles.ParticlePreset.galaxy.configuration)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .galaxySplit:
            mainSystem.stop()
            for (index, system) in letterSystems.enumerated() {
                system.rootEntity.position = AetherParticles.letterPositions[index]
                system.update(with: AetherParticles.ParticlePreset.galaxySplit.configuration)
                system.start()
            }
            
        case .stableState:
            mainSystem.stop()
            let config = AetherParticles.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [1.5, 1.5, 1.5],
                birthRate: 10,
                colorConfig: .evolving(
                    start: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 0.5, green: 0.0, blue: 0.5, alpha: 0.9
                    )),
                    end: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7
                    ))
                ),
                bounds: BoundingBox(min: [-3, -3, -3], max: [3, 3, 3]),
                acceleration: [0, 0.05, 0],
                speed: 0.1,
                lifetime: 3.0
            )
            letterSystems.forEach { system in
                system.update(with: config)
                system.start()
            }
            
        case .finalBurst:
            mainSystem.stop()
            let config = AetherParticles.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [8, 8, 8],
                birthRate: 200,
                colorConfig: .evolving(
                    start: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 0.5, green: 0.0, blue: 0.5, alpha: 0.6
                    )),
                    end: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0
                    ))
                ),
                bounds: BoundingBox(min: [-8, -8, -8], max: [8, 8, 8]),
                acceleration: [0, 2.0, 1.0],
                speed: 1.0,
                lifetime: 2.0
            )
            letterSystems.forEach { system in
                system.update(with: config)
                system.start()
            }
            
        case .complete:
            mainSystem.stop()
            letterSystems.forEach { $0.stop() }
        }
    }
}

struct WelcomeLetterAnimationView: View {
    @StateObject private var animation = WelcomeLetterAnimation()
    let onComplete: () -> Void
    
    var body: some View {
        RealityView { content in
            content.add(animation.rootEntity)
        }
        .task {
            animation.startAnimation()
            // Wait for all phases to complete
            try? await Task.sleep(for: .seconds(18)) // Sum of all phase durations
            onComplete()
        }
    }
}

#Preview {
    WelcomeLetterAnimationView {
        print("Animation complete")
    }
} 
