import Foundation
import MusicKit
import AVFAudio
import SwiftUI

@available(visionOS 2.0, *)
@MainActor
public class PulsarSymphony: ObservableObject, PulsarSymphonyProtocol {
    @Published public var isPlaying = false
    @Published public var canPlaySpatialAudio = true
    @Published public var isAuthorized = false
    @Published public var error: Error?
    
    public let player = ApplicationMusicPlayer.shared
    public let audioEngine = AVAudioEngine()
    internal var albumCache: [PulsarCategory: [Album]] = [:]
    internal var paginationStates: [PulsarCategory: PaginationState] = [:]
    
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
                self.error = PulsarError.audioSessionSetupFailed(error)
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
            throw PulsarError.playbackFailed
        }
        
        // Load detailed album with tracks
        let detailedAlbum = try await musicKitAlbum.loadDetails()
        guard let tracks = detailedAlbum.tracks else {
            throw PulsarError.playbackFailed
        }
        
        // Convert back to MusicKit tracks
        let musicKitTracks = tracks.compactMap { track -> MusicKit.Track? in
            guard let musicKitTrack = track as? MusicKitTrack else { return nil }
            return musicKitTrack.musicKitTrack
        }
        
        // Create a queue with the tracks
        try await player.queue = ApplicationMusicPlayer.Queue(for: musicKitTracks)
        try await player.play()  // Start playing immediately
    }
    
    public func play() async throws {
        try await player.play()
    }
    
    public func pause() async throws {
        try await player.pause()
    }
}