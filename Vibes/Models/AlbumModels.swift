import SwiftUI
import RealityKit
import MusicKit

@available(visionOS 2.0, *)
struct AlbumComponent: Component {
    let album: Album
    static let componentName = "Album"
} 