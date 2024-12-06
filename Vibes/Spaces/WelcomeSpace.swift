import SwiftUI
import RealityKit
import VibesParticles

struct WelcomeSpace: View {
    var body: some View {
        RealityView { content in
            // Create and add the particle system
            let particleSystem = AetherParticles.withPreset(.galaxy)
            content.add(particleSystem.rootEntity)
            
            // Start with particles inactive
            particleSystem.stop()
            
            // Fade in particles
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.easeIn(duration: 0.7)) {
                    particleSystem.start()
                }
            }
        }
    }
}

#Preview {
    WelcomeSpace()
} 