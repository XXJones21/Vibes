import Foundation
import MusicKit
import MusicService

// MARK: - Preview Helpers
@available(visionOS 2.0, *)
extension MusicKitAlbum {
    static var mock: MusicKitAlbum {
        MusicKitAlbum(Album.mock)
    }
}

// MARK: - Album Mocks
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
    
    // TODO: Add more mock albums for Gallery and particle effect testing
    static var mockAlbums: [Album] {
        // We'll expand this with different albums for testing various scenarios
        [mock]
    }
} 