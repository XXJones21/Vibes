import SwiftUI
import RealityKit

@available(visionOS 2.0, *)
struct WelcomeView: View {
    let onComplete: () -> Void
    @State private var opacity = 0.0
    @State private var showFireflies = false
    @State private var showGalaxy = false
    
    // Create PulseParticles instance
    @StateObject private var pulseParticles = PulseParticles()
    
    // Performance monitoring state
    @State private var lastMetrics: (TimeInterval, TimeInterval) = (0, 0) // (fireflies, galaxy)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                RadialGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.black]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
                .ignoresSafeArea()
                
                // RealityView to display particle effects
                RealityView { content in
                    content.add(pulseParticles.rootEntity)
                }
                .opacity(opacity)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // First effect: Fireflies
            showFireflies = true
            withAnimation(.easeIn(duration: 2.0)) {
                opacity = 1.0
            }
            
            // Create and apply fireflies effect
            let firefliesPreset = PulsePreset.fireflies
            let firefliesEffect = DefaultPulseEffect(preset: firefliesPreset)
            pulseParticles.addEffect(firefliesEffect)
            
            // Start performance monitoring
            monitorPerformance()
            
            // After 10 seconds, fade out fireflies
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                withAnimation(.easeOut(duration: 2.0)) {
                    opacity = 0.0
                }
                
                // Log fireflies performance
                let metrics = pulseParticles.detailedMetrics
                lastMetrics.0 = metrics.averageUpdateTime
                print("🎭 Fireflies Performance:")
                print("  Average Update Time: \(metrics.averageUpdateTime * 1000)ms")
                print("  Peak Update Time: \(metrics.peakUpdateTime * 1000)ms")
                print("  Average FPS: \(metrics.averageFrameRate)")
                
                // Start galaxy effect after fireflies fade out
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Remove fireflies effect
                    pulseParticles.removeAllEffects()
                    showFireflies = false
                    showGalaxy = true
                    
                    // Create and apply galaxy effect
                    let galaxyPreset = PulsePreset.galaxy
                    let galaxyEffect = DefaultPulseEffect(preset: galaxyPreset)
                    pulseParticles.addEffect(galaxyEffect)
                    
                    // Fade in galaxy
                    withAnimation(.easeIn(duration: 2.0)) {
                        opacity = 1.0
                    }
                    
                    // After 10 seconds of galaxy, fade out
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        withAnimation(.easeOut(duration: 2.0)) {
                            opacity = 0.0
                        }
                        
                        // Log galaxy performance
                        let metrics = pulseParticles.detailedMetrics
                        lastMetrics.1 = metrics.averageUpdateTime
                        print("🌌 Galaxy Performance:")
                        print("  Average Update Time: \(metrics.averageUpdateTime * 1000)ms")
                        print("  Peak Update Time: \(metrics.peakUpdateTime * 1000)ms")
                        print("  Average FPS: \(metrics.averageFrameRate)")
                        
                        // Complete the welcome sequence
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            pulseParticles.removeAllEffects()
                            onComplete()
                        }
                    }
                }
            }
        }
    }
    
    private func monitorPerformance() {
        // Check performance every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let metrics = pulseParticles.detailedMetrics
            
            // Log warnings if performance drops
            if metrics.averageFrameRate < 30 {
                print("⚠️ Low frame rate: \(Int(metrics.averageFrameRate)) FPS")
            }
            if metrics.averageUpdateTime > 0.016 {
                print("⚠️ High update time: \(metrics.averageUpdateTime * 1000)ms")
            }
            
            // Stop monitoring when sequence completes
            if !showFireflies && !showGalaxy {
                timer.invalidate()
                
                // Log final comparison
                print("📊 Performance Summary:")
                print("  Fireflies Avg Update: \(lastMetrics.0 * 1000)ms")
                print("  Galaxy Avg Update: \(lastMetrics.1 * 1000)ms")
            }
        }
    }
}

/// A default implementation of PulseEffect that uses a preset
@available(visionOS 2.0, *)
class DefaultPulseEffect: PulseEffect {
    public private(set) var state: PulseEffectState = .inactive
    public private(set) var staticProperties: PulseStaticProperties
    public var dynamicProperties: PulseDynamicProperties
    public var isDirty: Bool = true
    public var currentParticleSystem: ParticleEmitterComponent?
    
    init(preset: PulsePreset) {
        let configuration = preset.configuration
        self.staticProperties = PulseStaticProperties(configuration: configuration)
        self.dynamicProperties = PulseDynamicProperties(configuration: configuration)
    }
    
    public func updateDynamicProperties(_ particleSystem: inout ParticleEmitterComponent, deltaTime: Float) {
        // Update dynamic properties
        particleSystem.mainEmitter.birthRate = dynamicProperties.birthRate
        particleSystem.mainEmitter.color = dynamicProperties.color.realityKitColor
        particleSystem.mainEmitter.acceleration = .init(dynamicProperties.acceleration)
        
        // Update state if needed
        switch state {
        case .inactive:
            state = .active
        case .active:
            break // Continue normal updates
        case .transitioning(let progress):
            if progress >= 1.0 {
                state = .active
            }
        case .completed:
            break
        }
    }
    
    public func propertyDidChange(_ keyPath: AnyKeyPath) {
        // Handle property changes
        if keyPath == \PulseStaticProperties.emitterShape ||
           keyPath == \PulseStaticProperties.emitterSize ||
           keyPath == \PulseStaticProperties.speed ||
           keyPath == \PulseStaticProperties.lifetime {
            markDirty()
        }
        
        // Update particle system immediately for dynamic properties
        if var particleSystem = currentParticleSystem {
            updateDynamicProperties(&particleSystem, deltaTime: 0)
            currentParticleSystem = particleSystem
        }
    }
}

#Preview {
    WelcomeView {
        print("Welcome animation complete")
    }
} 