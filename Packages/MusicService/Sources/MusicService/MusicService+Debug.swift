import Foundation
import MusicKit

@available(visionOS 2.0, *)
extension VibesMusicService {
    /// Debug helper to analyze album metadata
    public func analyzeAlbum(title: String, artist: String) async throws {
        print("\n🔍 Analyzing album: \(title) by \(artist)")
        
        var request = MusicCatalogSearchRequest(term: "\(title) \(artist)", types: [Album.self])
        request.limit = 5
        let response = try await request.response()
        
        guard let album = response.albums.first(where: { 
            $0.title.localizedCaseInsensitiveContains(title) && 
            $0.artistName.localizedCaseInsensitiveContains(artist)
        }) else {
            print("❌ Album not found")
            return
        }
        
        print("\n📀 Album Details:")
        print("ID: \(album.id)")
        print("Title: \(album.title)")
        print("Artist: \(album.artistName)")
        print("Release Date: \(album.releaseDate?.formatted() ?? "Unknown")")
        
        print("\n🎵 Audio Variants:")
        if let variants = album.audioVariants {
            variants.forEach { variant in
                print("- \(variant)")
            }
        } else {
            print("No audio variants found")
        }
        
        print("\n🏷 Genres:")
        album.genreNames.forEach { genre in
            print("- \(genre)")
        }
        
        if let notes = album.editorialNotes {
            print("\n📝 Editorial Notes:")
            if let short = notes.short {
                print("Short: \(short)")
            }
            if let standard = notes.standard {
                print("Standard: \(standard)")
            }
        }
        
        print("\n🔊 Other Audio Info:")
        print("Track Count: \(album.trackCount ?? 0)")
        if let playParams = album.playParameters {
            print("Play Parameters: \(String(describing: playParams))")
        }
        
        // Get detailed track info
        let detailRequest = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: album.id)
        let detailResponse = try await detailRequest.response()
        
        if let detailedAlbum = detailResponse.items.first {
            print("\n💿 Tracks:")
            if let tracks = detailedAlbum.tracks {
                for track in tracks {
                    print("\n🎵 Track: \(track.title)")
                    print("Duration: \(track.duration ?? 0) seconds")
                    if let trackPlayParams = track.playParameters {
                        print("Track Parameters: \(String(describing: trackPlayParams))")
                    }
                }
            }
        }
    }
} 