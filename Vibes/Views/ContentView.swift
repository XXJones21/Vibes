import SwiftUI
import RealityKit
import MusicService

struct ContentView: View {
    @EnvironmentObject private var musicService: VibesMusicService
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var showWelcome = true
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView {
                    withAnimation(.easeOut(duration: 0.7)) {
                        showWelcome = false
                    }
                    Task {
                        await dismissImmersiveSpace()
                    }
                }
            } else {
                Group {
                    if musicService.isAuthorized {
                        Gallery()
                    } else {
                        AuthorizationView()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await openImmersiveSpace(id: "Welcome")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(VibesMusicService())
} 