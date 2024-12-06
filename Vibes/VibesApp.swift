import SwiftUI
import MusicService
import VibesParticles

@main
struct VibesApp: App {
    @StateObject private var musicService = VibesMusicService()
    
    init() {
        // Register the particle system
        VibesParticles.registerSystem()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicService)
        }
        
        ImmersiveSpace(id: "Welcome") {
            WelcomeSpace()
        }
    }
} 