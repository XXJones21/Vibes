import SwiftUI
import RealityKit
import _RealityKit_SwiftUI

/// Creates an immersive welcome animation using ethereal particle effects
@available(visionOS 2.0, *)
class AetherWelcomeAnimation: ObservableObject {
    // Root entity that will host all particle systems
    private let rootEntity = Entity()
    
    // Individual letter particle systems
    private var letterSystems: [PulseSystem] = []
    
    // Main particle system for overall effects
    private var mainSystem: NexusSystem
    
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
        mainSystem = NexusSystem()
        mainSystem.entity.position = sceneCenter
        rootEntity.addChild(mainSystem.entity)
        
        // Create letter systems around scene center
        for i in 0..<5 {
            let letterSystem = Self.forLetterPosition(i, center: sceneCenter)
            letterSystems.append(letterSystem)
            rootEntity.addChild(letterSystem.entity)
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
            let globeConfig = PulseConfiguration(
                shape: .sphere,
                size: [25, 25, 25],  // Large emission volume around user
                birthRate: 100,
                color: .rainbow,
                acceleration: [0, 0, 0],  // No initial pull, just appear
                speed: 0.1,  // Slow, dreamy movement
                lifetime: 4.0
            )
            mainSystem.entity.position = sceneCenter
            mainSystem.update(with: globeConfig)
            mainSystem.start()
            letterSystems.forEach { $0.stop() }
            
        case .centerPull:
            // Now pull existing particles to center
            let pullConfig = PulseConfiguration(
                shape: .sphere,
                size: [0, 0, 0],  // No new emission
                birthRate: 0,  // No new particles
                color: .rainbow,
                acceleration: sceneCenter - mainSystem.entity.position,
                speed: 1.0,  // Faster for the pull effect
                lifetime: 3.0
            )
            mainSystem.update(with: pullConfig)
            
        case .textFormation:
            mainSystem.stop()
            // Position letter systems around scene center
            for (index, system) in letterSystems.enumerated() {
                let offset = Self.letterOffsetFromCenter(index)
                system.entity.position = sceneCenter + offset
                let galaxyConfig = PulseConfiguration(
                    shape: .sphere,
                    size: [0.05, 0.05, 0.05],
                    birthRate: 150,
                    color: .evolving(
                        start: .purple,
                        end: .blue
                    ),
                    acceleration: [0, 0.1, 0],
                    speed: 0.5,
                    lifetime: 2.0
                )
                system.update(with: galaxyConfig)
                system.start()
            }
            
        case .stableState:
            // Gentle floating movement with color pulsing
            let floatingConfig = PulseConfiguration(
                shape: .sphere,
                size: [0.05, 0.05, 0.05],
                birthRate: 75,
                color: .evolving(
                    start: .purple,
                    end: .blue
                ),
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
            let burstConfig = PulseConfiguration(
                shape: .sphere,
                size: [0.05, 0.05, 0.05],
                birthRate: 300,
                color: .rainbow,
                acceleration: [0, 2.0, 1.0],
                speed: 2.0,
                lifetime: 2.0
            )
            mainSystem.entity.position = sceneCenter
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
    
    private static func forLetterPosition(_ index: Int, center: SIMD3<Float>) -> PulseSystem {
        precondition(index >= 0 && index < 5, "Letter index out of bounds")
        
        let system = PulseSystem()
        let offset = letterOffsetFromCenter(index)
        system.entity.position = center + offset
        return system
    }
} 