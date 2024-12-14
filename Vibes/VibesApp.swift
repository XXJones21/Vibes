import SwiftUI
import RealityKit

@main
@available(visionOS 2.0, *)
struct VibesApp: App {
    @StateObject private var musicService = PulsarSymphony()
    
    init() {
        // No need to register components manually with PulseParticles
        // The system handles registration automatically when effects are created
    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicService)
        }
        
        // Temporarily disabled
        /*ImmersiveSpace(id: "Welcome") {
            WelcomeSpace()
        }*/
    }
} 