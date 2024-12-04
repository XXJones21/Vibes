import SwiftUI
import RealityKit

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Custom animated loading indicator
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.purple.opacity(0.5), .blue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 8
                    )
                    .frame(width: 80, height: 80)
                
                // Inner spinning circle
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: rotation))
                    .scaleEffect(scale)
            }
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    scale = 0.8
                }
            }
            
            // Loading message
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark) // Force dark mode for consistent look
    }
}

#Preview {
    LoadingView(message: "Loading your music...")
} 