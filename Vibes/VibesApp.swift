import SwiftUI
import RealityKit

@main
@available(visionOS 2.0, *)
struct VibesApp: App {
    @StateObject private var musicService = PulsarSymphony()
    
    init() {
        // Register particle components
        if #available(visionOS 2.0, *) {
            // Register NexusComponent for large-scale immersive effects
            NexusComponent.registerComponent()
            // Register PulseComponent for album visualizations
            PulseComponent.registerComponent()
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