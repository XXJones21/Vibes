import SwiftUI
import RealityKit

@available(visionOS 2.0, *)
struct WelcomeView: View {
    let onComplete: () -> Void
    @State private var opacity = 0.0
    @State private var showFireflies = false
    @State private var showGalaxy = false
    
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
            
            if showFireflies {
                AetherParticlesView(preset: .fireflies)
                    .opacity(opacity)
            }
            
            if showGalaxy {
                AetherParticlesView(preset: .galaxy, isLargeScale: true)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // First effect: Fireflies
            showFireflies = true
            withAnimation(.easeIn(duration: 2.0)) {
                opacity = 1.0
            }
            
            // After 5 seconds, fade out fireflies
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeOut(duration: 2.0)) {
                    opacity = 0.0
                }
                
                // Start galaxy effect after fireflies fade out
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showFireflies = false
                    showGalaxy = true
                    
                    // Fade in galaxy
                    withAnimation(.easeIn(duration: 2.0)) {
                        opacity = 1.0
                    }
                    
                    // After 6 seconds of galaxy, fade out
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                        withAnimation(.easeOut(duration: 2.0)) {
                            opacity = 0.0
                        }
                        
                        // Complete the welcome sequence
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            onComplete()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView {
        print("Welcome animation complete")
    }
} 