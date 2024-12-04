import Foundation
import MusicKit
import AVFAudio

@available(visionOS 2.0, *)
struct PaginationState {
    var isLoading = false
    var currentPage = 0
    var hasNextPage = true
    var items: [Album] = []
    
    mutating func reset() {
        isLoading = false
        currentPage = 0
        hasNextPage = true
        items.removeAll()
    }
}

@available(visionOS 2.0, *)
extension VibesMusicService {
    func loadMoreContent(for category: VibesAlbumCategory) async throws -> [Album] {
        guard let state = paginationStates[category] else {
            throw MusicServiceError.albumFetchFailed
        }
        
        guard !state.isLoading && state.hasNextPage else {
            return []
        }
        
        paginationStates[category]?.isLoading = true
        defer { paginationStates[category]?.isLoading = false }
        
        let offset = state.currentPage * Constants.pageSize
        let albums = try await fetchAlbumsByCategory(category, offset: offset)
        
        paginationStates[category]?.currentPage += 1
        paginationStates[category]?.hasNextPage = !albums.isEmpty
        paginationStates[category]?.items.append(contentsOf: albums)
        
        return Array(albums)
    }
    
    func resetPagination(for category: VibesAlbumCategory) {
        paginationStates[category]?.reset()
    }
    
    private func fetchAlbumsByCategory(_ category: VibesAlbumCategory, offset: Int = 0) async throws -> [Album] {
        switch category {
        case .recentlyPlayed:
            let albums = try await fetchRecentlyPlayed()
            return filterSpatialAudio(albums)
            
        case .topCharts:
            var request = MusicCatalogSearchRequest(term: "top charts dolby atmos", types: [Album.self])
            request.limit = Constants.pageSize
            let response = try await request.response()
            let albums = Array(response.albums)
            return filterSpatialAudio(albums)
            
        case .newReleases:
            let recommendationRequest = MusicPersonalRecommendationsRequest()
            let recommendationResponse = try await recommendationRequest.response()
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            
            let allItems = recommendationResponse.recommendations.flatMap { $0.items }
            let albums = allItems.compactMap { $0 as? Album }
            let recentAlbums = albums.filter { album in
                guard let releaseDate = album.releaseDate else { return false }
                return releaseDate >= thirtyDaysAgo
            }
            
            return filterSpatialAudio(recentAlbums)
            
        case .spatial:
            var request = MusicCatalogSearchRequest(term: "spatial audio dolby atmos", types: [Album.self])
            request.limit = Constants.pageSize
            let response = try await request.response()
            let albums = Array(response.albums)
            return filterSpatialAudio(albums)
            
        case .editorsPicks:
            var request = MusicCatalogSearchRequest(term: "editors choice featured dolby atmos", types: [Album.self])
            request.limit = Constants.pageSize
            let response = try await request.response()
            let albums = Array(response.albums)
            return filterSpatialAudio(albums)
        }
    }
    
    /// Helper function to filter for spatial audio support
    private func filterSpatialAudio(_ albums: [Album]) -> [Album] {
        let filteredAlbums = albums.filter { album in
            if let variants = album.audioVariants {
                return variants.contains(where: { variant in
                    variant == .dolbyAtmos
                })
            }
            return false
        }
        return Array(filteredAlbums.prefix(Constants.pageSize))
    }
} 

