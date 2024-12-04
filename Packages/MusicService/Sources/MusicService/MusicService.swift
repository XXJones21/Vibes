import Foundation
import MusicKit
import AVFAudio
import SwiftUI

@available(visionOS 2.0, *)
@MainActor
public class VibesMusicService: ObservableObject, MusicProviding {
    @Published public var isPlaying = false
    @Published public var canPlaySpatialAudio = true
    @Published public var isAuthorized = false
    @Published public var error: Error?
    
    public let player = ApplicationMusicPlayer.shared
    public let audioEngine = AVAudioEngine()
    internal var albumCache: [VibesAlbumCategory: [Album]] = [:]
    internal var paginationStates: [VibesAlbumCategory: PaginationState] = [:]
    
    public static let pageSize = 25
    
    internal let audioSession = AVAudioSession.sharedInstance()
    
    public init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Check playback state every 0.5 seconds
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updatePlaybackState()
            }
        }
    }
    
    private func updatePlaybackState() {
        Task {
            do {
                let state = try await player.state
                isPlaying = state.playbackStatus == .playing
            } catch {
                print("Failed to update playback state:", error)
            }
        }
    }
    
    // MARK: - Authorization and Setup
    
    public func checkAuthorization() async {
        let status = await MusicAuthorization.request()
        isAuthorized = status == .authorized
        
        if isAuthorized {
            do {
                try await configureAudioSession()
            } catch {
                self.error = MusicServiceError.audioSessionSetupFailed(error)
            }
        }
    }
    
    internal func configureAudioSession() async throws {
        try audioSession.setCategory(.playback, mode: .default, options: [])
        try audioSession.setActive(true)
    }
    
    internal func deactivateAudioSession() {
        do {
            try audioSession.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            print("Failed to deactivate audio session:", error)
        }
    }
    
    // MARK: - Playback Control
    
    public func queueAlbum(_ album: AlbumRepresentable) async throws {
        try await checkSubscription()
        
        guard let musicKitAlbum = album as? MusicKitAlbum else {
            throw MusicServiceError.playbackFailed
        }
        
        let request = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(rawValue: musicKitAlbum.id))
        let response = try await request.response()
        
        guard let albumToPlay = response.items.first else {
            throw MusicServiceError.playbackFailed
        }
        
        try await player.queue = ApplicationMusicPlayer.Queue(for: [albumToPlay])
    }
    
    public func play() async throws {
        try await player.play()
    }
    
    public func pause() async throws {
        try await player.pause()
    }
}