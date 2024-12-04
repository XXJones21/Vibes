import Foundation
import MusicKit
import SwiftUI
import Swift

@available(iOS 15.0, macOS 12.0, visionOS 1.0, *)
extension VibesMusicService {
    // MARK: - Album Management
    
    public func fetchAlbums(category: VibesAlbumCategory) async throws -> [AlbumRepresentable] {
        // Check cache first
        if let cached = self.albumCache[category] {
            return cached.map(MusicKitAlbum.init)
        }
        
        let albums = try await fetchMusicKitAlbums(category: category)
        self.albumCache[category] = albums
        return albums.map(MusicKitAlbum.init)
    }
    
    private func fetchMusicKitAlbums(category: VibesAlbumCategory) async throws -> [Album] {
        switch category {
        case .recentlyPlayed:
            return try await fetchRecentlyPlayed()
        case .recommended:
            return try await fetchRecommended()
        case .spatial:
            return try await fetchSpatialAudioAlbums()
        case .playlists:
            return try await fetchPlaylists()
        }
    }
    
    /// Fetches recently played albums
    internal func fetchRecentlyPlayed() async throws -> [Album] {
        let request = MusicLibraryRequest<Album>()
        let response = try await request.response()
        let items = Array(response.items)
        return items.count > Constants.pageSize ? Array(items[..<Constants.pageSize]) : items
    }
    
    /// Fetches recommended albums
    internal func fetchRecommended() async throws -> [Album] {
        var request = MusicCatalogSearchRequest(term: "Featured", types: [Album.self])
        request.limit = Constants.pageSize
        let response = try await request.response()
        return Array(response.albums)
    }
    
    /// Fetches spatial audio albums
    internal func fetchSpatialAudioAlbums() async throws -> [Album] {
        var request = MusicCatalogSearchRequest(term: "Spatial Audio", types: [Album.self])
        request.limit = Constants.pageSize
        let response = try await request.response()
        return Array(response.albums)
    }
    
    /// Fetches playlists
    internal func fetchPlaylists() async throws -> [Album] {
        var request = MusicLibraryRequest<Album>()
        request.limit = Constants.pageSize
        let response = try await request.response()
        return Array(response.items)
    }
    
    public func fetchArtwork(for album: AlbumRepresentable, width: Int, height: Int) async throws -> Image? {
        guard let artwork = album.artwork else { return nil }
        let imageData = try await artwork.data(width: width, height: height)
        #if os(visionOS)
        guard let cgImage = try? await createCGImage(from: imageData) else { return nil }
        #else
        guard let uiImage = UIImage(data: imageData),
              let cgImage = uiImage.cgImage else { return nil }
        #endif
        return Image(cgImage, scale: 1.0, label: Text(album.title))
    }
    
    public func loadAlbumDetails(_ album: AlbumRepresentable) async throws -> AlbumRepresentable {
        guard let musicKitAlbum = album as? MusicKitAlbum else {
            throw MusicServiceError.albumFetchFailed
        }
        return try await musicKitAlbum.loadDetails()
    }
    
    func clearCache() {
        self.albumCache.removeAll()
    }
    
    #if os(visionOS)
    private func createCGImage(from data: Data) async throws -> CGImage? {
        let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        return imageSource.flatMap { CGImageSourceCreateImageAtIndex($0, 0, nil) }
    }
    #endif
} 