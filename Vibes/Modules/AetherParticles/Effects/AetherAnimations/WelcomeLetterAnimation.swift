import SwiftUI
import RealityKit
import _RealityKit_SwiftUI

/// Creates an immersive welcome animation using ethereal particle effects
@available(visionOS 2.0, *)
class AetherWelcomeAnimation: ObservableObject {
    // Root entity that will host all particle systems
    private let rootEntity = Entity()
    
    // Individual letter particle systems
    private var letterSystems: [AetherParticles] = []
    
    // Main particle system for overall effects
    private var mainSystem: AetherParticles
    
    // Center point in scene space
    private let sceneCenter: SIMD3<Float>
    
    // Animation phases
    enum AetherAnimationPhase {
        case initial
        case globeFormation
        case centerPull
        case textFormation
        case stableState
        case finalBurst
    }
    
    @Published private(set) var currentPhase: AetherAnimationPhase = .initial
    
    // Animation durations
    private let phaseDurations: [AetherAnimationPhase: TimeInterval] = [
        .globeFormation: 4.0,
        .centerPull: 3.0,
        .textFormation: 3.0,
        .stableState: 2.0,
        .finalBurst: 2.0
    ]
    
    // Completion callback
    private var onComplete: (() -> Void)?
    
    // MARK: - Initialization
    
    init(content: RealityViewContent, onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
        
        // Convert window center to scene space
        let windowCenter = Point3D(x: 0, y: 0, z: 0)
        self.sceneCenter = content.convert(windowCenter, 
            from: .local,
            to: SceneRealityCoordinateSpace.scene
        )
        
        // Initialize main system at scene center
        mainSystem = AetherParticles(configuration: .default)
        mainSystem.rootEntity.position = sceneCenter
        rootEntity.addChild(mainSystem.rootEntity)
        
        // Create letter systems around scene center
        for i in 0..<5 {
            let letterSystem = Self.forLetterPosition(i, center: sceneCenter)
            letterSystems.append(letterSystem)
            rootEntity.addChild(letterSystem.rootEntity)
        }
    }
    
    // MARK: - Properties
    
    var entity: Entity { rootEntity }
    
    func start() {
        advancePhase(.globeFormation)
    }
    
    // MARK: - Private Methods
    
    private func advancePhase(_ phase: AetherAnimationPhase) {
        updateParticlesForPhase(phase)
        
        // Schedule next phase
        if let duration = phaseDurations[phase] {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                guard let self = self else { return }
                
                switch phase {
                case .initial: break
                case .globeFormation: self.advancePhase(.centerPull)
                case .centerPull: self.advancePhase(.textFormation)
                case .textFormation: self.advancePhase(.stableState)
                case .stableState: self.advancePhase(.finalBurst)
                case .finalBurst: self.onComplete?()
                }
            }
        }
    }
    
    private func updateParticlesForPhase(_ phase: AetherAnimationPhase) {
        currentPhase = phase
        
        switch phase {
        case .initial:
            mainSystem.stop()
            letterSystems.forEach { $0.stop() }
            
        case .globeFormation:
            // Start particles appearing around the user
            let globeConfig = AetherConfiguration(
                emitterShape: .sphere,
                emitterSize: [25, 25, 25],  // Large emission volume around user
                birthRate: 100,
                colorConfig: AetherParticles.randomRainbowColor(),
                bounds: AetherParticles.standardBounds,
                acceleration: [0, 0, 0],  // No initial pull, just appear
                speed: 0.1,  // Slow, dreamy movement
                lifetime: 4.0
            )
            mainSystem.rootEntity.position = sceneCenter
            mainSystem.update(with: globeConfig)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .centerPull:
            // Now pull existing particles to center
            let pullConfig = AetherConfiguration(
                emitterShape: .sphere,
                emitterSize: [0, 0, 0],  // No new emission
                birthRate: 0,  // No new particles
                colorConfig: AetherParticles.randomRainbowColor(),
                bounds: AetherParticles.standardBounds,
                acceleration: sceneCenter - mainSystem.rootEntity.position,
                speed: 1.0,  // Faster for the pull effect
                lifetime: 3.0
            )
            mainSystem.update(with: pullConfig)
            
        case .textFormation:
            mainSystem.stop()
            // Position letter systems around scene center
            for (index, system) in letterSystems.enumerated() {
                let offset = Self.letterOffsetFromCenter(index)
                system.rootEntity.position = sceneCenter + offset
                let galaxyConfig = AetherPreset.galaxySplit.configuration
                let halfSizeConfig = AetherConfiguration(
                    emitterShape: galaxyConfig.emitterShape,
                    emitterSize: [0.05, 0.05, 0.05],
                    birthRate: galaxyConfig.birthRate * 1.5,
                    colorConfig: galaxyConfig.colorConfig,
                    bounds: AetherParticles.standardBounds,
                    acceleration: galaxyConfig.acceleration,
                    speed: galaxyConfig.speed,
                    lifetime: galaxyConfig.lifetime
                )
                system.update(with: halfSizeConfig)
                system.start()
            }
            
        case .stableState:
            // Gentle floating movement with color pulsing
            let floatingConfig = AetherConfiguration(
                emitterShape: .sphere,
                emitterSize: [0.05, 0.05, 0.05],
                birthRate: 75,
                colorConfig: .evolving(
                    start: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 0.5, green: 0.0, blue: 0.5, alpha: 0.8
                    )),
                    end: .single(ParticleEmitterComponent.ParticleEmitter.Color(
                        red: 0.3, green: 0.0, blue: 0.8, alpha: 0.6
                    ))
                ),
                bounds: AetherParticles.standardBounds,
                acceleration: [0, 0.05, 0],
                speed: 0.1,
                lifetime: 2.0
            )
            letterSystems.forEach { system in
                system.update(with: floatingConfig)
                system.start()
            }
            
        case .finalBurst:
            // Burst from scene center
            let burstConfig = AetherConfiguration(
                emitterShape: .sphere,
                emitterSize: [0.05, 0.05, 0.05],
                birthRate: 300,
                colorConfig: AetherParticles.randomRainbowColor(),
                bounds: AetherParticles.standardBounds,
                acceleration: [0, 2.0, 1.0],
                speed: 2.0,
                lifetime: 2.0
            )
            mainSystem.rootEntity.position = sceneCenter
            mainSystem.update(with: burstConfig)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
        }
    }
    
    private static func letterOffsetFromCenter(_ index: Int) -> SIMD3<Float> {
        let spacing: Float = 1.0
        return [
            Float(index - 2) * spacing,  // X offset from center (-2 to center the word)
            0,                           // Y stays at 0
            0                            // Z stays at converted depth
        ]
    }
    
    private static func forLetterPosition(_ index: Int, center: SIMD3<Float>) -> AetherParticles {
        precondition(index >= 0 && index < 5, "Letter index out of bounds")
        
        let system = AetherParticles(configuration: AetherPreset.galaxySplit.configuration)
        let offset = letterOffsetFromCenter(index)
        system.rootEntity.position = center + offset
        return system
    }
} 