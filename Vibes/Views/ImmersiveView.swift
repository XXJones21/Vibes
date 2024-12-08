import SwiftUI
import RealityKit
import MusicService

@available(visionOS 2.0, *)
struct ImmersiveView: View {
    @EnvironmentObject private var musicService: VibesMusicService
    
    var body: some View {
        RealityView { content in
            // Create and add entities
            let rootEntity = Entity()
            content.add(rootEntity)
            
            // Add visualizer entities
            // Implementation coming soon
        } update: { content in
            // Update visualizer based on music playback
            // Implementation coming soon
        }
    }
}

#Preview {
    ImmersiveView()
        .environmentObject(VibesMusicService())
} 