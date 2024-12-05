import SwiftUI
import RealityKit
import MusicService

struct ContentView: View {
    @EnvironmentObject private var musicService: VibesMusicService
    @State private var showWelcome = true
    @State private var isLoading = true
    @State private var isInitialLoad = true
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView {
                    withAnimation(.easeOut(duration: 0.7)) {
                        showWelcome = false
                    }
                }
            } else {
                Group {
                    if musicService.isAuthorized {
                        Gallery()
                            .task {
                                if isInitialLoad {
                                    isInitialLoad = false
                                    isLoading = false
                                }
                            }
                    } else {
                        AuthorizationView()
                    }
                }
                .opacity(showWelcome ? 0 : 1)
                
                if isLoading {
                    LoadingView(message: "Loading your music...")
                }
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