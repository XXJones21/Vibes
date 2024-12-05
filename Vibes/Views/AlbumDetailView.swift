import SwiftUI
import MusicService
import MusicKit

struct AlbumDetailView: View {
    let album: AlbumRepresentable
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var musicService: VibesMusicService
    
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

private struct ArtworkImage: View {
    let artwork: ArtworkRepresentable
    let width: CGFloat
    let height: CGFloat
    @State private var imageData: Data?
    
    var body: some View {
        Group {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .tint(Color.purple)
                    .task {
                        do {
                            self.imageData = try await artwork.data(width: Int(width), height: Int(height))
                        } catch {
                            print("Failed to load artwork:", error)
                        }
                    }
            }
        }
    }
}

#Preview {
    let mockAlbum = MusicKitAlbum(Album.mock)
    
    return AlbumDetailView(album: mockAlbum)
        .environmentObject(VibesMusicService())
}

// MARK: - Preview Helpers
extension Album {
    static var mock: Album {
        get {
            let decoder = JSONDecoder()
            let json = """
            {
                "id": "1234",
                "type": "albums",
                "href": "/v1/catalog/us/albums/1234",
                "attributes": {
                    "name": "Preview Album",
                    "artistName": "Preview Artist",
                    "artwork": null,
                    "contentRating": null,
                    "editorialNotes": null,
                    "isCompilation": false,
                    "isComplete": true,
                    "isSingle": false,
                    "playParams": null,
                    "releaseDate": "2023-12-04",
                    "trackCount": 12,
                    "url": "https://music.apple.com/us/album/1234"
                }
            }
            """.data(using: .utf8)!
            
            return try! decoder.decode(Album.self, from: json)
        }
    }
} 
