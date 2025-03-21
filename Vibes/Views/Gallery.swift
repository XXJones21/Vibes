import SwiftUI
import RealityKit

@available(visionOS 2.0, *)
struct Gallery: View {
    @StateObject private var viewModel = GalleryViewModel()
    @EnvironmentObject private var musicService: PulsarSymphony
    @State private var showingAuthAlert = false
    
    var body: some View {
        ScrollView {
            if viewModel.albumsByCategory.isEmpty {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading Albums...")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                VStack(alignment: .leading, spacing: 60) {
                    ForEach(viewModel.albumsByCategory.keys.sorted(), id: \.self) { category in
                        AlbumRow(
                            title: category.rawValue,
                            albums: viewModel.albumsByCategory[category] ?? [],
                            onAlbumTap: { album in
                                Task {
                                    try? await viewModel.playAlbum(album, using: musicService)
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 40)
            }
        }
        .task {
            do {
                try await viewModel.loadInitialContent(musicService)
            } catch {
                print("Failed to load content:", error)
                showingAuthAlert = true
            }
        }
        .alert("Authorization Required", isPresented: $showingAuthAlert) {
            Button("Authorize") {
                Task {
                    await musicService.checkAuthorization()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please authorize access to Apple Music to view your albums.")
        }
    }
}

struct AlbumRow: View {
    let title: String
    let albums: [AlbumRepresentable]
    let onAlbumTap: (AlbumRepresentable) -> Void
    @State private var dragOffset: CGFloat = 0
    @State private var dragVelocity: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(albums, id: \.id) { album in
                        AlbumCard(album: album, onTap: onAlbumTap)
                    }
                }
                .padding(.horizontal, 40)
                .offset(x: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if !isDragging {
                                isDragging = true
                            }
                            let translation = value.translation.width
                            dragOffset = translation
                            dragVelocity = value.predictedEndTranslation.width - translation
                        }
                        .onEnded { value in
                            isDragging = false
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                let finalOffset = dragOffset + dragVelocity * 0.5
                                let maxOffset = CGFloat(albums.count - 1) * -230
                                dragOffset = max(maxOffset, min(0, finalOffset))
                            }
                        }
                )
            }
            .scrollDisabled(isDragging)
        }
    }
}

struct AlbumCard: View {
    let album: AlbumRepresentable
    let onTap: (AlbumRepresentable) -> Void
    @State private var isHovered = false
    
    // CD case dimensions (in meters)
    private let cardWidth: Float = 0.142  // Standard CD width
    private let cardHeight: Float = 0.125 // Standard CD height
    private let cardDepth: Float = 0.01   // Thickness of a CD case
    
    var body: some View {
        Button(action: { onTap(album) }) {
            VStack(alignment: .leading, spacing: 12) {
                // Album Artwork with RealityKit integration
                AlbumArtworkView(album: album, width: cardWidth, height: cardHeight, depth: cardDepth, isHovered: isHovered)
                    .frame(width: 180, height: 180)
                    .shadow(radius: isHovered ? 12 : 4)
                    .scaleEffect(isHovered ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
                    .onHover { hovering in
                        isHovered = hovering
                    }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(album.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(album.artistName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(width: 180, alignment: .leading)
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
    }
}

struct AlbumArtworkView: View {
    let album: AlbumRepresentable
    let width: Float
    let height: Float
    let depth: Float
    let isHovered: Bool
    @State private var artworkTexture: MaterialParameters?
    @State private var modelEntity: ModelEntity?
    
    var body: some View {
        RealityView { content in
            let entity = Entity()
            
            // Create a box for the CD case
            let mesh = MeshResource.generateBox(width: width, height: height, depth: depth)
            
            // Create a physically based material for realistic appearance
            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: .white)
            material.roughness = .init(floatLiteral: 0.3) // Slightly glossy
            material.metallic = .init(floatLiteral: 0.1)  // Slight metallic sheen
            
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            // Position the entity with more depth
            modelEntity.position.z = -0.15
            
            // Add slight rotation for better 3D effect
            modelEntity.transform.rotation = simd_quatf(angle: .pi * 0.05, axis: [0, 1, 0])
            
            // Store reference for animations
            self.modelEntity = modelEntity
            
            entity.addChild(modelEntity)
            content.add(entity)
            
            // Load artwork
            Task {
                print("Starting artwork load for album:", album.title)
                if let artwork = album.artwork {
                    do {
                        print("Fetching artwork data for:", album.title)
                        let imageData = try await artwork.data(width: 300, height: 300)
                        print("Got artwork data for:", album.title, "size:", imageData.count)
                        
                        // Convert data to CGImage
                        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
                            print("Failed to create CGImage for:", album.title)
                            return
                        }
                        
                        // Generate texture from CGImage
                        let texture = try await TextureResource.generate(from: cgImage, options: .init(semantic: .color))
                        print("Generated texture for:", album.title)
                        
                        // Update the material with the album artwork
                        var updatedMaterial = PhysicallyBasedMaterial()
                        updatedMaterial.baseColor = .init(texture: .init(texture))
                        updatedMaterial.roughness = .init(floatLiteral: 0.3)
                        updatedMaterial.metallic = .init(floatLiteral: 0.1)
                        
                        modelEntity.model?.materials = [updatedMaterial]
                        print("Updated material for:", album.title)
                    } catch {
                        print("Failed to load artwork for \(album.title):", error)
                    }
                } else {
                    print("No artwork available for album:", album.title)
                }
            }
        } update: { content in
            guard let modelEntity = modelEntity else { return }
            
            // Animate rotation and position when hovered
            if isHovered {
                modelEntity.transform.rotation = simd_quatf(angle: .pi * 0.15, axis: [0, 1, 0])
                modelEntity.position.z = -0.1
                
                // Add subtle floating animation
                let floatAnimation = FromToByAnimation(
                    name: "float",
                    from: modelEntity.position.y,
                    to: modelEntity.position.y + 0.01,
                    duration: 1.0
                )
                
                // Configure animation to repeat and autoReverse
                let animation = try? AnimationResource.generate(with: floatAnimation)
                if let animation = animation {
                    modelEntity.position.y += 0.005
                    modelEntity.playAnimation(animation, transitionDuration: 0.5, startsPaused: false)
                }
            } else {
                modelEntity.transform.rotation = simd_quatf(angle: .pi * 0.05, axis: [0, 1, 0])
                modelEntity.position.z = -0.15
                modelEntity.position.y = 0
                modelEntity.stopAllAnimations()
            }
        }
    }
}

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var currentCategory: PulsarCategory = .spatial
    @Published var albumsByCategory: [PulsarCategory: [AlbumRepresentable]] = [:]
    @Published var selectedAlbum: AlbumRepresentable?
    @Published var isPlaying = false
    @Published var error: Error?
    
    func loadInitialContent(_ musicService: PulsarSymphony) async throws {
        guard musicService.isAuthorized else {
            await musicService.checkAuthorization()
            guard musicService.isAuthorized else {
                throw PulsarError.authorizationFailed
            }
            return
        }
        
        // Load albums for each category
        for category in PulsarCategory.allCases {
            let albums = try await musicService.fetchAlbums(category: category)
            DispatchQueue.main.async {
                self.albumsByCategory[category] = albums
            }
        }
    }
    
    func playAlbum(_ album: AlbumRepresentable, using musicService: PulsarSymphony) async throws {
        try await musicService.queueAlbum(album)
        try await musicService.play()
        isPlaying = true
    }
    
    func pausePlayback(using musicService: PulsarSymphony) async {
        try? await musicService.pause()
        isPlaying = false
    }
}

#Preview {
    Gallery()
        .environmentObject(PulsarSymphony())
}

