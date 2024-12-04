import Foundation
import MusicKit
import AVFAudio

@available(iOS 15.0, macOS 12.0, visionOS 1.0, *)
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

@available(iOS 15.0, macOS 12.0, visionOS 1.0, *)
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
        let term = switch category {
        case .playlists: "spatial audio"
        case .recommended: "dolby atmos"
        case .recentlyPlayed: "recently played spatial audio"
        case .spatial: "spatial audio"
        }
        
        var request = MusicCatalogSearchRequest(term: term, types: [Album.self])
        request.limit = Constants.pageSize
        request.offset = offset
        
        let response = try await request.response()
        return Array(response.albums)
    }
} 

