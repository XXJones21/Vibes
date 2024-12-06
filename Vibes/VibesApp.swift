import SwiftUI
import MusicService
import RealityKit
import VibesParticles

@main
struct VibesApp: App {
    @StateObject private var musicService = VibesMusicService()
    
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
        
        ImmersiveSpace(id: "Welcome") {
            WelcomeSpace()
        }
    }
} 