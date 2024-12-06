import SwiftUI
import RealityKit
import VibesParticles

@available(visionOS 2.0, *)
struct WelcomeView: View {
    let onComplete: () -> Void
    @State private var opacity = 0.0
    @State private var showTagline = false
    @State private var showParticles = false
    @State private var animation: WelcomeLetterAnimation?
    
    var body: some View {
        ZStack {
            // Background gradient
            RadialGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.black]),
                center: .center,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            if showParticles {
                // Particle animation using RealityView
                RealityView { content in
                    // Create animation with proper coordinate space
                    let letterAnimation = WelcomeLetterAnimation(content: content)
                    animation = letterAnimation
                    content.add(letterAnimation.entity)
                    letterAnimation.start()
                    
                    // Handle completion in the update closure
                } update: { content in
                    if let animation = animation,
                       animation.currentPhase == .finalBurst {
                        withAnimation(.easeOut(duration: 0.7)) {
                            opacity = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                onComplete()
                            }
                        }
                    }
                }
            }
            
            // Tagline
            if showTagline {
                Text("Experience Music in a New Dimension")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .opacity(opacity)
        .onAppear {
            // Fade in view
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
            }
            
            // Show tagline after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.7)) {
                    showTagline = true
                }
            }
            
            // Start particle animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showParticles = true
            }
        }
    }
}

#Preview {
    WelcomeView {
        print("Welcome animation complete")
    }
} 