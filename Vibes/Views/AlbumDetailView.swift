import SwiftUI

@available(visionOS 2.0, *)
struct AlbumDetailView: View {
    let album: AlbumRepresentable
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @EnvironmentObject private var musicService: PulsarSymphony
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Album artwork
                    if let artwork = album.artwork {
                        ArtworkImage(artwork: artwork, width: 300, height: 300)
                            .frame(width: 300, height: 300)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                    }
                    
                    // Album info
                    VStack(spacing: 8) {
                        Text(album.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text(album.artistName)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Playback controls
                    HStack(spacing: 40) {
                        Button(action: {
                            Task {
                                do {
                                    if musicService.isPlaying {
                                        try await musicService.pause()
                                    } else {
                                        try await musicService.queueAlbum(album)
                                        try await musicService.play()
                                    }
                                } catch {
                                    print("Playback error:", error)
                                }
                            }
                        }) {
                            Image(systemName: musicService.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(.ultraThinMaterial)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

@available(visionOS 2.0, *)
private struct ArtworkImage: View {
    let artwork: ArtworkRepresentable
    let width: CGFloat
    let height: CGFloat
    @State private var modelEntity: ModelEntity?
    @EnvironmentObject private var musicService: PulsarSymphony
    
    // CD case dimensions (in meters)
    private let cardWidth: Float = 0.3  // Larger for detail view
    private let cardHeight: Float = 0.3 // Larger for detail view
    private let cardDepth: Float = 0.01 // Standard thickness
    
    var body: some View {
        RealityView { content in
            let entity = Entity()
            
            // Create a box for the CD case
            let mesh = MeshResource.generateBox(width: cardWidth, height: cardHeight, depth: cardDepth)
            
            // Create initial material
            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: .white)
            material.roughness = .init(floatLiteral: 0.3)
            material.metallic = .init(floatLiteral: 0.1)
            
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.position.z = -0.3  // Position further back for detail view
            modelEntity.transform.rotation = simd_quatf(angle: .pi * 0.05, axis: [0, 1, 0])
            
            self.modelEntity = modelEntity
            entity.addChild(modelEntity)
            content.add(entity)
            
            // Load artwork
            Task {
                do {
                    let imageData = try await artwork.data(width: Int(width), height: Int(height))
                    
                    // Convert data to CGImage
                    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                          let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
                        print("Failed to create CGImage")
                        return
                    }
                    
                    // Generate texture
                    let texture = try await TextureResource.generate(from: cgImage, options: .init(semantic: .color))
                    
                    // Update material with artwork
                    var updatedMaterial = PhysicallyBasedMaterial()
                    updatedMaterial.baseColor = .init(texture: .init(texture))
                    updatedMaterial.roughness = .init(floatLiteral: 0.3)
                    updatedMaterial.metallic = .init(floatLiteral: 0.1)
                    
                    modelEntity.model?.materials = [updatedMaterial]
                } catch {
                    print("Failed to load artwork:", error)
                }
            }
        } update: { content in
            guard let modelEntity = modelEntity else { return }
            
            // Add subtle floating animation
            let floatAnimation = FromToByAnimation(
                name: "float",
                from: modelEntity.position.y,
                to: modelEntity.position.y + 0.01,
                duration: 1.0
            )
            
            // Configure animation
            if let animation = try? AnimationResource.generate(with: floatAnimation) {
                modelEntity.position.y += 0.005
                modelEntity.playAnimation(animation, transitionDuration: 0.5, startsPaused: false)
            }
        }
    }
}

#Preview {
    AlbumDetailView(album: PreviewData.mockAlbum)
        .environmentObject(PulsarSymphony())
} 

