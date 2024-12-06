import SwiftUI
import MusicService

@main
struct VibesApp: App {
    @StateObject private var musicService = VibesMusicService()
    
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