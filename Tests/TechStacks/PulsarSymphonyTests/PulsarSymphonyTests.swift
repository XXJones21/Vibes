import XCTest
@testable import Vibes

final class PulsarSymphonyTests: XCTestCase {
    // Test properties
    var musicService: MusicService!
    
    override func setUpWithError() throws {
        // Set up before each test
        try super.setUpWithError()
        musicService = MusicService()
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        musicService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Authorization Tests
    
    func testAuthorizationRequest() async throws {
        // Test authorization request flow
        let status = await musicService.requestAuthorization()
        XCTAssertNotNil(status, "Authorization status should not be nil")
    }
    
    // MARK: - Album Tests
    
    func testFetchAlbums() async throws {
        // Test album fetching
        let albums = try await musicService.fetchAlbums(category: .recentlyPlayed)
        XCTAssertFalse(albums.isEmpty, "Should fetch at least one album")
    }
    
    func testAlbumCaching() async throws {
        // Test album caching mechanism
        let firstFetch = try await musicService.fetchAlbums(category: .recentlyPlayed)
        let secondFetch = try await musicService.fetchAlbums(category: .recentlyPlayed)
        
        XCTAssertEqual(firstFetch.count, secondFetch.count, "Cached results should match")
    }
    
    // MARK: - Playlist Tests
    
    func testPlaylistHandling() async throws {
        // Test playlist operations
        let playlists = try await musicService.fetchPlaylists()
        XCTAssertNotNil(playlists, "Should fetch playlists")
    }
    
    // MARK: - Performance Tests
    
    func testFetchPerformance() throws {
        measure {
            // Test performance of album fetching
            let expectation = expectation(description: "Fetch albums")
            
            Task {
                do {
                    let _ = try await musicService.fetchAlbums(category: .recentlyPlayed)
                    expectation.fulfill()
                } catch {
                    XCTFail("Failed to fetch albums: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
} 