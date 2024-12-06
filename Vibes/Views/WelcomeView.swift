import SwiftUI
import RealityKit
import VibesParticles

@available(visionOS 2.0, *)
struct WelcomeView: View {
    let onComplete: () -> Void
    @State private var opacity = 0.0
    @State private var showTagline = false
    @State private var showParticles = false
    @State private var showTitle = false
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
            
            VStack(spacing: 40) {
                if showTitle {
                    Text("VIBES")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .transition(.scale.combined(with: .opacity))
                }
                
                if showTagline {
                    Text("Experience Music in a New Dimension")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            if showParticles {
                // Particle animation using RealityView
                RealityView { content in
                    // Create animation with proper coordinate space
                    let letterAnimation = WelcomeLetterAnimation(content: content) {
                        // Animation complete callback
                        withAnimation(.easeOut(duration: 0.7)) {
                            opacity = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                onComplete()
                            }
                        }
                    }
                    animation = letterAnimation
                    content.add(letterAnimation.entity)
                    letterAnimation.start()
                } update: { content in
                    if let animation = animation {
                        switch animation.currentPhase {
                        case .textFormation:
                            withAnimation(.easeIn(duration: 0.7)) {
                                showTitle = true
                            }
                        case .stableState:
                            withAnimation(.easeOut(duration: 0.7)) {
                                showTagline = true
                            }
                        default:
                            break
                        }
                    }
                }
            }
        }
        .opacity(opacity)
        .onAppear {
            // Initial fade in
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
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