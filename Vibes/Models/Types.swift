import Foundation
import MusicKit

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
    var isPlaying: Bool
    var currentTime: TimeInterval
    var duration: TimeInterval
    var volume: Float
    
    init(isPlaying: Bool = false,
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
    let frequencies: [Float]
    let waveform: [Float]
    let beat: Float
    let energy: Float
    
    init(frequencies: [Float] = [],
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
    var count: Int
    var size: Float
    var speed: Float
    var color: SIMD3<Float>
    var lifetime: Float
    
    init(count: Int = 1000,
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

public enum VibesAlbumCategory: String, CaseIterable {
    case recentlyPlayed = "Recently Played"
    case recommended = "Recommended"
    case spatial = "Spatial Audio"
    case playlists = "Playlists"
}

struct LoadState {
    var albums: [Album] = []
    var hasMore = true
    var isLoading = false
    var nextOffset = 0
}
