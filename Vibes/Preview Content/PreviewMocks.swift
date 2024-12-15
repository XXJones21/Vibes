import Foundation
import MusicKit

// MARK: - Preview Data
@available(visionOS 2.0, *)
enum PreviewData {
    static var mockAlbum: AlbumRepresentable {
        MusicKitAlbum(Album.mock)
    }
    
    static var mockAlbums: [AlbumRepresentable] {
        Album.mockAlbums.map(MusicKitAlbum.init)
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
    
    static var mockAlbums: [Album] {
        [mock]
    }
} 