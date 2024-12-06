import RealityKit
import SwiftUI
import VibesParticles

@available(visionOS 2.0, *)
class WelcomeAnimation: ObservableObject {
    // Root entity that will host all particle systems
    internal var rootEntity: Entity
    
    // Main particle system for initial phases
    private var mainSystem: ParticleSystem
    
    // Letter particle systems for split phase
    private var letterSystems: [ParticleSystem] = []
    
    // Animation phase tracking
    @Published private(set) var currentPhase: AnimationPhase = .initial {
        didSet {
            print("Animation phase changed: \(oldValue) -> \(currentPhase)")
        }
    }
    
    // Animation phases
    enum AnimationPhase {
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
    
    init() {
        // Create root entity
        rootEntity = Entity()
        
        // Initialize main particle system with firefly preset
        mainSystem = .withPreset(.fireflies)
        rootEntity.addChild(mainSystem.rootEntity)
        
        // Create letter systems (initially hidden)
        for i in 0..<5 {
            let system = ParticleSystem.forLetterPosition(i)
            letterSystems.append(system)
            rootEntity.addChild(system.rootEntity)
        }
        
        // Position in space
        rootEntity.position = [0, 0, 0]
    }
    
    func startAnimation() {
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
        switch phase {
        case .initial:
            mainSystem.stop()
            letterSystems.forEach { $0.stop() }
            
        case .fireflyFloat:
            mainSystem.update(with: ParticlePreset.fireflies.configuration)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .centerPull:
            let config = ParticleSystem.ParticleConfiguration(
                emitterShape: .sphere,
                emitterSize: [2, 2, 2],
                birthRate: 0,
                colorConfig: .evolving(
                    start: .multiple([
                        .init(color: .systemRed.withAlphaComponent(0.8), location: 0.0),
                        .init(color: .systemYellow.withAlphaComponent(0.8), location: 0.2),
                        .init(color: .systemGreen.withAlphaComponent(0.8), location: 0.4),
                        .init(color: .systemBlue.withAlphaComponent(0.8), location: 0.6),
                        .init(color: .systemPurple.withAlphaComponent(0.8), location: 0.8)
                    ]),
                    end: .single(.systemPurple.withAlphaComponent(0.7))
                ),
                acceleration: [0, -0.5, -2.0],
                speed: 0.5
            )
            mainSystem.update(with: config)
            letterSystems.forEach { $0.stop() }
            
        case .galaxyForm:
            mainSystem.update(with: ParticlePreset.galaxy.configuration)
            letterSystems.forEach { $0.stop() }
            
        case .galaxySplit:
            mainSystem.stop()
            letterSystems.forEach { system in
                system.update(with: ParticlePreset.galaxySplit.configuration)
                system.start()
            }
            
        case .stableState:
            mainSystem.stop()
            letterSystems.forEach { system in
                let config = ParticleSystem.ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [1.5, 1.5, 1.5],
                    birthRate: 10,
                    colorConfig: .evolving(
                        start: .single(.systemPurple.withAlphaComponent(0.9)),
                        end: .single(.systemBlue.withAlphaComponent(0.7))
                    ),
                    acceleration: [0, 0.05, 0],
                    speed: 0.1
                )
                system.update(with: config)
            }
            
        case .finalBurst:
            mainSystem.stop()
            letterSystems.forEach { system in
                let config = ParticleSystem.ParticleConfiguration(
                    emitterShape: .sphere,
                    emitterSize: [8, 8, 8],
                    birthRate: 0,
                    colorConfig: .evolving(
                        start: .single(.systemPurple.withAlphaComponent(0.6)),
                        end: .single(.white.withAlphaComponent(0))
                    ),
                    acceleration: [0, 2.0, 1.0],
                    speed: 1.0
                )
                system.update(with: config)
            }
            
        case .complete:
            mainSystem.stop()
            letterSystems.forEach { $0.stop() }
        }
    }
} 
