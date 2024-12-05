import Foundation
import MusicKit
import SwiftUI

@available(visionOS 2.0, *)
extension VibesMusicService {
    // MARK: - Album Management
    
    public func fetchAlbums(category: VibesAlbumCategory) async throws -> [AlbumRepresentable] {
        // Cache-first approach
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
        case .topCharts:
            return try await fetchTopCharts()
        case .newReleases:
            return try await fetchNewReleases()
        case .spatial:
            return try await fetchSpatialAudioAlbums()
        case .editorsPicks:
            return try await fetchEditorsPicks()
        }
    }
    
    /// Helper function to filter for spatial audio support
    private func filterSpatialAudio(_ albums: [Album]) -> [Album] {
        // First get all albums that definitely support Dolby Atmos
        let spatialAlbums = albums.filter { album in
            // Skip singles
            guard !(album.title.localizedCaseInsensitiveContains("single") ||
                   album.title.localizedCaseInsensitiveContains(" - single")) else {
                return false
            }
            
            // Check audio variants first
            if let variants = album.audioVariants {
                return variants.contains(where: { variant in
                    variant == .dolbyAtmos || variant == .spatialAudio
                })
            }
            
            // If no variants, check if it's in our catalog search results
            // but filter out test/demo content
            let isTestContent = album.title.localizedCaseInsensitiveContains("test") ||
                              album.title.localizedCaseInsensitiveContains("demo") ||
                              album.title.localizedCaseInsensitiveContains("noise")
            
            return !isTestContent && (
                album.title.localizedCaseInsensitiveContains("atmos") ||
                album.title.localizedCaseInsensitiveContains("spatial") ||
                album.artistName.localizedCaseInsensitiveContains("atmos") ||
                album.artistName.localizedCaseInsensitiveContains("spatial")
            )
        }
        
        // If we found any spatial audio albums, return those
        if !spatialAlbums.isEmpty {
            return Array(spatialAlbums.prefix(Constants.albumsPerRow))
        }
        
        // Otherwise, return the original albums (up to albumsPerRow)
        return Array(albums.prefix(Constants.albumsPerRow))
    }
    
    /// Fetches recently played albums
    @available(visionOS 2.0, *)
    internal func fetchRecentlyPlayed() async throws -> [Album] {
        var request = MusicLibraryRequest<Album>()
        request.limit = Constants.pageSize * 2  // Get more items to filter from
        let response = try await request.response()
        let items = Array(response.items)
        
        // Apply spatial audio filtering to library items
        return filterSpatialAudio(items)
    }
    
    /// Fetches top charting albums
    internal func fetchTopCharts() async throws -> [Album] {
        var allAlbums: [Album] = []
        let requestsNeeded = (Constants.albumsPerRow + Constants.pageSize - 1) / Constants.pageSize
        let maxOffset = requestsNeeded * Constants.pageSize
        
        for offset in stride(from: 0, to: maxOffset, by: Constants.pageSize) {
            var request = MusicCatalogSearchRequest(term: "top hits", types: [Album.self])
            request.limit = Constants.pageSize
            request.offset = offset
            let response = try await request.response()
            
            // Filter out singles
            let fullAlbums = response.albums.filter { album in
                !(album.title.localizedCaseInsensitiveContains("single") ||
                  album.title.localizedCaseInsensitiveContains(" - single"))
            }
            
            allAlbums.append(contentsOf: fullAlbums)
            
            if allAlbums.count >= Constants.albumsPerRow {
                break
            }
        }
        return filterSpatialAudio(allAlbums)
    }
    
    /// Fetches new releases
    internal func fetchNewReleases() async throws -> [Album] {
        var allAlbums: [Album] = []
        let requestsNeeded = (Constants.albumsPerRow + Constants.pageSize - 1) / Constants.pageSize
        let maxOffset = requestsNeeded * Constants.pageSize
        
        for offset in stride(from: 0, to: maxOffset, by: Constants.pageSize) {
            var request = MusicCatalogSearchRequest(term: "new releases", types: [Album.self])
            request.limit = Constants.pageSize
            request.offset = offset
            let response = try await request.response()
            
            // Filter out singles
            let fullAlbums = response.albums.filter { album in
                !(album.title.localizedCaseInsensitiveContains("single") ||
                  album.title.localizedCaseInsensitiveContains(" - single"))
            }
            
            allAlbums.append(contentsOf: fullAlbums)
            
            if allAlbums.count >= Constants.albumsPerRow {
                break
            }
        }
        return filterSpatialAudio(allAlbums)
    }
    
    /// Fetches spatial audio albums
    internal func fetchSpatialAudioAlbums() async throws -> [Album] {
        var allAlbums: [Album] = []
        let requestsNeeded = (Constants.albumsPerRow + Constants.pageSize - 1) / Constants.pageSize
        let maxOffset = requestsNeeded * Constants.pageSize
        
        // Try multiple search terms to get better results
        let searchTerms = ["dolby atmos", "spatial audio", "360 audio"]
        
        for term in searchTerms {
            for offset in stride(from: 0, to: maxOffset, by: Constants.pageSize) {
                var request = MusicCatalogSearchRequest(term: term, types: [Album.self])
                request.limit = Constants.pageSize
                request.offset = offset
                let response = try await request.response()
                
                // Filter out singles
                let fullAlbums = response.albums.filter { album in
                    !(album.title.localizedCaseInsensitiveContains("single") ||
                      album.title.localizedCaseInsensitiveContains(" - single"))
                }
                
                allAlbums.append(contentsOf: fullAlbums)
                
                if allAlbums.count >= Constants.albumsPerRow * 2 {  // Get more to filter
                    break
                }
            }
        }
        
        // Remove duplicates
        let uniqueAlbums = Array(Set(allAlbums))
        return filterSpatialAudio(uniqueAlbums)
    }
    
    /// Fetches editor's picks
    internal func fetchEditorsPicks() async throws -> [Album] {
        var allAlbums: [Album] = []
        let requestsNeeded = (Constants.albumsPerRow + Constants.pageSize - 1) / Constants.pageSize
        let maxOffset = requestsNeeded * Constants.pageSize
        
        for offset in stride(from: 0, to: maxOffset, by: Constants.pageSize) {
            var request = MusicCatalogSearchRequest(term: "featured hits", types: [Album.self])
            request.limit = Constants.pageSize
            request.offset = offset
            let response = try await request.response()
            
            // Filter out singles
            let fullAlbums = response.albums.filter { album in
                !(album.title.localizedCaseInsensitiveContains("single") ||
                  album.title.localizedCaseInsensitiveContains(" - single"))
            }
            
            allAlbums.append(contentsOf: fullAlbums)
            
            if allAlbums.count >= Constants.albumsPerRow {
                break
            }
        }
        return filterSpatialAudio(allAlbums)
    }
    
    public func fetchArtwork(for album: AlbumRepresentable, width: Int, height: Int) async throws -> Image? {
        guard let artwork = album.artwork else { return nil }
        let imageData = try await artwork.data(width: width, height: height)
        guard let cgImage = try? await createCGImage(from: imageData) else { return nil }
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
    
    private func createCGImage(from data: Data) async throws -> CGImage? {
        let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        return imageSource.flatMap { CGImageSourceCreateImageAtIndex($0, 0, nil) }
    }
} 