import SwiftUI
import RealityKit
import MusicService

struct Gallery: View {
    @StateObject private var viewModel = GalleryViewModel()
    @EnvironmentObject private var musicService: VibesMusicService
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 60) {
                ForEach(viewModel.albumsByCategory.keys.sorted(), id: \.self) { category in
                    AlbumRow(
                        title: category.rawValue,
                        albums: viewModel.albumsByCategory[category] ?? [],
                        onAlbumTap: { album in
                            viewModel.selectedAlbum = album
                        }
                    )
                }
            }
            .padding(.vertical, 40)
        }
        .task {
            try? await viewModel.loadInitialContent(musicService)
        }
        
        if let selectedAlbum = viewModel.selectedAlbum {
            VStack(spacing: 10) {
                Text(selectedAlbum.title)
                    .font(.headline)
                Text(selectedAlbum.artistName)
                    .font(.subheadline)
                
                HStack(spacing: 20) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.playAlbum(selectedAlbum, using: musicService)
                            } catch {
                                print("Failed to play album:", error)
                            }
                        }
                    }) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                    }
                    
                    if viewModel.isPlaying {
                        Button(action: {
                            Task {
                                await viewModel.pausePlayback(using: musicService)
                            }
                        }) {
                            Image(systemName: "pause.fill")
                                .font(.title2)
                        }
                    }
                }
                .padding()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct AlbumRow: View {
    let title: String
    let albums: [MusicService.AlbumRepresentable]
    let onAlbumTap: (MusicService.AlbumRepresentable) -> Void
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
    let album: MusicService.AlbumRepresentable
    let onTap: (MusicService.AlbumRepresentable) -> Void
    @State private var isHovered = false
    @EnvironmentObject private var musicService: VibesMusicService
    
    // CD case dimensions (in meters)
    private let cardWidth: Float = 0.142  // Standard CD width
    private let cardHeight: Float = 0.125 // Standard CD height
    private let cardDepth: Float = 0.01   // Thickness of a CD case
    
    var body: some View {
        Button(action: {
            onTap(album)
            Task {
                do {
                    try await musicService.queueAlbum(album)
                    try await musicService.play()
                } catch {
                    print("Failed to play album:", error)
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Album Artwork with RealityKit integration
                AlbumArtworkView(album: album, width: cardWidth, height: cardHeight, depth: cardDepth)
                    .frame(width: 180, height: 180)
                    .shadow(radius: isHovered ? 15 : 8)
                
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
        .scaleEffect(isHovered ? 1.08 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { isHovered = $0 }
    }
}

struct AlbumArtworkView: View {
    let album: MusicService.AlbumRepresentable
    let width: Float
    let height: Float
    let depth: Float
    @State private var artworkTexture: MaterialParameters?
    
    var body: some View {
        RealityView { content in
            let entity = Entity()
            
            // Create a box for the CD case
            let mesh = MeshResource.generateBox(width: width, height: height, depth: depth)
            let material = UnlitMaterial(color: .white)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            // Position the entity with more depth
            modelEntity.position.z = -0.2
            
            // Add slight rotation for better 3D effect
            modelEntity.transform.rotation = simd_quatf(angle: .pi * 0.05, axis: [0, 1, 0])
            
            entity.addChild(modelEntity)
            content.add(entity)
            
            // Load artwork
            Task {
                if let artwork = album.artwork {
                    do {
                        let imageData = try await artwork.data(width: 300, height: 300)
                        if let uiImage = UIImage(data: imageData),
                           let cgImage = uiImage.cgImage {
                            let texture = try await TextureResource.generate(from: cgImage, options: .init(semantic: .color))
                            var material = UnlitMaterial()
                            material.color = .init(texture: .init(texture))
                            modelEntity.model?.materials = [material]
                        }
                    } catch {
                        print("Failed to load artwork:", error)
                    }
                }
            }
        }
    }
}

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var currentCategory: MusicService.VibesAlbumCategory = .spatial
    @Published var albumsByCategory: [MusicService.VibesAlbumCategory: [MusicService.AlbumRepresentable]] = [:]
    @Published var selectedAlbum: MusicService.AlbumRepresentable?
    @Published var isPlaying = false
    @Published var error: Error?
    
    func loadInitialContent(_ musicService: VibesMusicService) async throws {
        // Load albums for all categories
        for category in MusicService.VibesAlbumCategory.allCases {
            do {
                let albums = try await musicService.fetchAlbums(category: category)
                albumsByCategory[category] = albums
            } catch {
                print("Failed to load albums for category \(category): \(error)")
                // Continue loading other categories even if one fails
                albumsByCategory[category] = []
            }
        }
    }
    
    func playAlbum(_ album: MusicService.AlbumRepresentable, using musicService: VibesMusicService) async throws {
        try await musicService.queueAlbum(album)
        try await musicService.play()
        isPlaying = true
    }
    
    func pausePlayback(using musicService: VibesMusicService) async {
        do {
            try await musicService.pause()
            isPlaying = false
        } catch {
            print("Failed to pause playback:", error)
        }
    }
}

#Preview {
    Gallery()
        .environmentObject(VibesMusicService())
}

