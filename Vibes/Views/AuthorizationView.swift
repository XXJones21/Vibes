import SwiftUI

@available(visionOS 2.0, *)
struct AuthorizationView: View {
    @State private var isAuthorizing = false
    @EnvironmentObject private var musicService: PulsarSymphony
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Vibes")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("To get started, we need access to Apple Music")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Button(action: {
                Task {
                    await musicService.checkAuthorization()
                }
            }) {
                Text("Authorize Apple Music")
                    .font(.headline)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    AuthorizationView()
        .environmentObject(PulsarSymphony())
} 