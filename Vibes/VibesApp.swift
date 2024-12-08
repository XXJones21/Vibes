import SwiftUI
import RealityKit

@main
@available(visionOS 2.0, *)
struct VibesApp: App {
    @StateObject private var musicService = PulsarSymphony()
    
    init() {
        // Register particle systems
        if #available(visionOS 2.0, *) {
            // Register NexusSystem for large-scale immersive effects
            NexusSystem.registerSystem()
            // Register PulseSystem for album visualizations
            PulseSystem.registerSystem()
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