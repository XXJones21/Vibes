import MusicKit
import AVFAudio

/// Main interface for PulsarSymphony music services
public enum PulsarSymphony {
    /// Core playback state type
    public struct PlaybackState {
        public let isPlaying: Bool
        public let currentTime: TimeInterval
        public let duration: TimeInterval
    }
    
    /// Audio session configuration
    public struct AudioSession {
        public let category: AVAudioSession.Category
        public let mode: AVAudioSession.Mode
        public let options: AVAudioSession.CategoryOptions
    }
    
    /// Music authorization service
    public static var authorization: MusicAuthorization {
        get async {
            await MusicAuthorization.currentStatus
        }
    }
    
    /// Playback controller
    public static let playback = PlaybackController()
} 