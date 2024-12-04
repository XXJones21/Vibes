import Foundation
import MusicKit

public enum Constants {
    static let pageSize: Int = 25
    static let albumsPerRow: Int = 12  // Maximum albums to show per category row
}

public enum MusicGenre {
    case pop
    case rock
    case jazz
    case classical
    case electronic
    case hiphop
    case other
    
    var description: String {
        switch self {
        case .pop:
            return "Pop"
        case .rock:
            return "Rock"
        case .jazz:
            return "Jazz"
        case .classical:
            return "Classical"
        case .electronic:
            return "Electronic"
        case .hiphop:
            return "Hip Hop"
        case .other:
            return "Other"
        }
    }
}

public struct PlaybackState {
    public var isPlaying: Bool
    public var currentTime: TimeInterval
    public var duration: TimeInterval
    public var volume: Float
    
    public init(isPlaying: Bool = false,
         currentTime: TimeInterval = 0,
         duration: TimeInterval = 0,
         volume: Float = 1.0) {
        self.isPlaying = isPlaying
        self.currentTime = currentTime
        self.duration = duration
        self.volume = volume
    }
}

public struct AudioVisualizationData {
    public let frequencies: [Float]
    public let waveform: [Float]
    public let beat: Float
    public let energy: Float
    
    public init(frequencies: [Float] = [],
         waveform: [Float] = [],
         beat: Float = 0,
         energy: Float = 0) {
        self.frequencies = frequencies
        self.waveform = waveform
        self.beat = beat
        self.energy = energy
    }
}

public struct ParticleSettings {
    public var count: Int
    public var size: Float
    public var speed: Float
    public var color: SIMD3<Float>
    public var lifetime: Float
    
    public init(count: Int = 1000,
         size: Float = 0.1,
         speed: Float = 1.0,
         color: SIMD3<Float> = SIMD3<Float>(1, 1, 1),
         lifetime: Float = 2.0) {
        self.count = count
        self.size = size
        self.speed = speed
        self.color = color
        self.lifetime = lifetime
    }
}

@available(visionOS 2.0, *)
public enum VibesAlbumCategory: String, CaseIterable, Comparable {
    case recentlyPlayed = "Recently Played"
    case topCharts = "Top Charts"
    case newReleases = "New Releases"
    case spatial = "Spatial Audio"
    case editorsPicks = "Editor's Picks"
    
    public static func < (lhs: VibesAlbumCategory, rhs: VibesAlbumCategory) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@available(visionOS 2.0, *)
public struct LoadState {
    public var albums: [AlbumRepresentable] = []
    public var hasMore = true
    public var isLoading = false
    public var nextOffset = 0
    
    public init(albums: [AlbumRepresentable] = [], hasMore: Bool = true, isLoading: Bool = false, nextOffset: Int = 0) {
        self.albums = albums
        self.hasMore = hasMore
        self.isLoading = isLoading
        self.nextOffset = nextOffset
    }
}

@available(visionOS 2.0, *)
public enum MusicServiceError: LocalizedError {
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
