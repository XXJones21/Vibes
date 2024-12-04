import Foundation
import MusicKit

public enum Constants {
    static let pageSize: Int = 25
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

public enum VibesAlbumCategory: String, CaseIterable, Comparable {
    case recentlyPlayed = "Recently Played"
    case recommended = "Recommended"
    case spatial = "Spatial Audio"
    case playlists = "Playlists"
    
    // Implement Comparable based on raw value
    public static func < (lhs: VibesAlbumCategory, rhs: VibesAlbumCategory) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

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

public enum MusicError: Error {
    case notAuthorized
    case artworkURLNotFound
    case subscriptionRequired
    case unknown
}
