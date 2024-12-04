import SwiftUI
import RealityKit
import MusicService

struct ContentView: View {
    @EnvironmentObject private var musicService: VibesMusicService
    @State private var isLoading = true
    @State private var isInitialLoad = true
    
    var body: some View {
        ZStack {
            Group {
                if musicService.isAuthorized {
                    Gallery()
                        .task {
                            if isInitialLoad {
                                try? await Task.sleep(for: .seconds(2))
                                isInitialLoad = false
                                isLoading = false
                            }
                        }
                } else {
                    AuthorizationView()
                }
            }
            
            if isLoading {
                LoadingView(message: "Loading your music...")
            }
        }
        .task {
            isLoading = true
            await musicService.checkAuthorization()
            if !musicService.isAuthorized {
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(VibesMusicService())
} 