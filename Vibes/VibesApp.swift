import SwiftUI
import RealityKit
import MusicKit
import MusicService

@main
struct VibesApp: App {
    @StateObject private var musicService = VibesMusicService()
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicService)
        }
    }
} 