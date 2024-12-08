import SwiftUI
import RealityKit
import VibesParticles

@main
@available(visionOS 2.0, *)
struct VibesApp: App {
    @StateObject private var musicService = PulsarSymphony()
    
    init() {
        // Register particle system
        if #available(visionOS 2.0, *) {
            VibesParticles.registerSystem()
        }
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