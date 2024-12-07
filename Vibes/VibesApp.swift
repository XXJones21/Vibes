import SwiftUI
import MusicService
import RealityKit
import VibesKit

@main
@available(visionOS 2.0, *)
struct VibesApp: App {
    @StateObject private var musicService = VibesMusicService()
    
    init() {
        // Register particle system
        if #available(visionOS 2.0, *) {
            AetherSystem.registerSystem()
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