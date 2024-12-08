import Foundation
import MusicKit
import SwiftUI

@available(visionOS 2.0, *)
public enum PulsarCategory: String, CaseIterable, Comparable {
    case recentlyPlayed = "Recently Played"
    case topCharts = "Top Charts"
    case newReleases = "New Releases"
    case spatial = "Spatial Audio"
    case editorsPicks = "Editor's Picks"
    
    public static func < (lhs: PulsarCategory, rhs: PulsarCategory) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@available(visionOS 2.0, *)
public enum PulsarError: LocalizedError {
    case noActiveSubscription
    case playbackFailed
    case spatialAudioNotAvailable
    case authorizationFailed
    case audioSessionSetupFailed(Error)
    case audioEngineSetupFailed(Error)
    case albumFetchFailed
    case headTrackingNotAvailable
    case artworkURLNotFound
    
    public var errorDescription: String? {
        switch self {
        case .noActiveSubscription:
            return "Active Apple Music subscription required"
        case .playbackFailed:
            return "Failed to play the selected track"
        case .spatialAudioNotAvailable:
            return "Spatial Audio not available on this device"
        case .authorizationFailed:
            return "Failed to authorize Apple Music access"
        case .audioSessionSetupFailed(let error):
            return "Failed to setup audio session: \(error.localizedDescription)"
        case .audioEngineSetupFailed(let error):
            return "Failed to setup audio engine: \(error.localizedDescription)"
        case .albumFetchFailed:
            return "Failed to fetch album details"
        case .headTrackingNotAvailable:
            return "Head tracking is not available on this device"
        case .artworkURLNotFound:
            return "Could not find artwork URL"
        }
    }
}

@available(visionOS 2.0, *)
public protocol PulsarSymphonyProtocol {
    func fetchAlbums(category: PulsarCategory) async throws -> [AlbumRepresentable]
    func fetchArtwork(for album: AlbumRepresentable, width: Int, height: Int) async throws -> Image?
    func loadAlbumDetails(_ album: AlbumRepresentable) async throws -> AlbumRepresentable
    func queueAlbum(_ album: AlbumRepresentable) async throws
    func play() async throws
    func pause() async throws
}

@available(visionOS 2.0, *)
public protocol AlbumRepresentable {
    var id: String { get }
    var catalogID: MusicItemID? { get }
    var subscriptionID: String? { get }
    var title: String { get }
    var artistName: String { get }
    var artwork: ArtworkRepresentable? { get }
    var tracks: [TrackRepresentable]? { get }
    func loadDetails() async throws -> Self
}

@available(visionOS 2.0, *)
public protocol ArtworkRepresentable {
    func data(width: Int, height: Int) async throws -> Data
}

@available(visionOS 2.0, *)
public protocol TrackRepresentable {
    var id: String { get }
    var title: String { get }
    var duration: TimeInterval { get }
}

// MARK: - Implementations
@available(visionOS 2.0, *)
public struct MusicKitAlbum: AlbumRepresentable {
    private let album: MusicKit.Album
    
    public init(_ album: MusicKit.Album) {
        self.album = album
    }
    
    public var id: String { album.id.rawValue }
    public var catalogID: MusicItemID? { album.id }
    public var subscriptionID: String? {
        return album.id.rawValue
    }
    public var title: String { album.title }
    public var artistName: String { album.artistName }
    public var artwork: ArtworkRepresentable? { album.artwork.map(MusicKitArtwork.init) }
    public var tracks: [TrackRepresentable]? { album.tracks?.map(MusicKitTrack.init) }
    
    public func loadDetails() async throws -> MusicKitAlbum {
        let detailedAlbum = try await album.with([.tracks, .artists])
        return MusicKitAlbum(detailedAlbum)
    }
}

@available(visionOS 2.0, *)
public struct MusicKitArtwork: ArtworkRepresentable {
    private let artwork: MusicKit.Artwork
    
    public init(_ artwork: MusicKit.Artwork) {
        self.artwork = artwork
    }
    
    public func data(width: Int, height: Int) async throws -> Data {
        guard let url = artwork.url(width: width, height: height) else {
            throw PulsarError.artworkURLNotFound
        }
        return try await URLSession.shared.data(from: url).0
    }
}

@available(visionOS 2.0, *)
public struct MusicKitTrack: TrackRepresentable {
    private let track: MusicKit.Track
    
    public init(_ track: MusicKit.Track) {
        self.track = track
    }
    
    public var id: String { track.id.rawValue }
    public var title: String { track.title }
    public var duration: TimeInterval { track.duration ?? 0 }
    
    public var musicKitTrack: MusicKit.Track { track }
} 