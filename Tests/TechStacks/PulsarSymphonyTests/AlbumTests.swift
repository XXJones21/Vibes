import XCTest
@testable import Vibes

final class AlbumTests: XCTestCase {
    // Test properties
    var musicService: MusicService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        musicService = MusicService()
    }
    
    override func tearDownWithError() throws {
        musicService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Album Category Tests
    
    func testAlbumCategories() {
        // Test all album categories
        let categories: [AlbumCategory] = [
            .recentlyPlayed,
            .recentlyAdded,
            .favorites
        ]
        
        for category in categories {
            XCTAssertNotNil(category.description, "Category should have a description")
        }
    }
    
    // MARK: - Album Fetching Tests
    
    func testFetchByCategory() async throws {
        // Test fetching albums for each category
        for category in AlbumCategory.allCases {
            let albums = try await musicService.fetchAlbums(category: category)
            XCTAssertNotNil(albums, "Should fetch albums for \(category)")
        }
    }
    
    func testAlbumMetadata() async throws {
        // Test album metadata
        let albums = try await musicService.fetchAlbums(category: .recentlyPlayed)
        
        guard let album = albums.first else {
            XCTFail("Should have at least one album")
            return
        }
        
        // Test required properties
        XCTAssertFalse(album.title.isEmpty, "Album should have a title")
        XCTAssertFalse(album.artist.isEmpty, "Album should have an artist")
        XCTAssertNotNil(album.artwork, "Album should have artwork")
    }
    
    // MARK: - Pagination Tests
    
    func testPagination() async throws {
        // Test pagination with different page sizes
        let pageSizes = [10, 20, 50]
        
        for pageSize in pageSizes {
            let albums = try await musicService.fetchAlbums(
                category: .recentlyAdded,
                limit: pageSize
            )
            XCTAssertLessThanOrEqual(albums.count, pageSize, "Should respect page size limit")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidCategory() async {
        // Test error handling for invalid category
        do {
            _ = try await musicService.fetchAlbums(category: .recentlyPlayed, limit: -1)
            XCTFail("Should throw an error for invalid limit")
        } catch {
            XCTAssertNotNil(error, "Should throw an error")
        }
    }
} 