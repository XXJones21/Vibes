import SwiftUI
import RealityKit
import MusicKit

struct AlbumLoadState: Equatable {
    var albums: [Album]
    var isLoading: Bool
    var error: Error?
    
    static func == (lhs: AlbumLoadState, rhs: AlbumLoadState) -> Bool {
        lhs.albums == rhs.albums && lhs.isLoading == rhs.isLoading && (lhs.error == nil) == (rhs.error == nil)
    }
}

struct AlbumComponent: Component {
    let album: Album
    static let componentName = "Album"
} 