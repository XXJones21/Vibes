import Foundation
import MusicKit
import AVFoundation
import SwiftUI

#if os(visionOS) || os(iOS)
import AVFAudio
#endif

public enum MusicServiceError: LocalizedError {
    case noActiveSubscription
    case playbackFailed
    case spatialAudioNotAvailable
    case authorizationFailed
    case audioSessionSetupFailed(Error)
    case audioEngineSetupFailed(Error)
    case albumFetchFailed
    case headTrackingNotAvailable
    
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
        }
    }
}

@MainActor
public class VibesMusicService: ObservableObject, MusicProviding {
    @Published public var isPlaying = false
    @Published public var canPlaySpatialAudio = false
    @Published public var isAuthorized = false
    @Published public var error: Error?
    
    public let player = ApplicationMusicPlayer.shared
    public let audioEngine = AVAudioEngine()
    internal var albumCache: [VibesAlbumCategory: [Album]] = [:]
    internal var paginationStates: [VibesAlbumCategory: PaginationState] = [:]
    
    public static let pageSize = 25
    
    #if os(visionOS) || os(iOS)
    private let audioSession = AVAudioSession.sharedInstance()
    #endif
    
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
        if let currentEntry = player.queue.currentEntry {
            Task {
                let item = try? await currentEntry.item
                isPlaying = item != nil
            }
        } else {
            isPlaying = false
        }
    }
    
    public func checkAuthorization() async {
        let status = await MusicAuthorization.request()
        isAuthorized = status == .authorized
        
        if isAuthorized {
            do {
                try await configureAudioSession()
                try await checkSubscriptionCapabilities()
            } catch {
                self.error = error
                isAuthorized = false
            }
        }
    }
    
    private func configureAudioSession() async throws {
        #if os(visionOS) || os(iOS)
        try audioSession.setCategory(.playback, mode: .default)
        try audioSession.setActive(true)
        #endif
    }
    
    public func play() async throws {
        try await player.play()
        isPlaying = true
    }
    
    public func pause() async throws {
        try await player.pause()
        isPlaying = false
    }
    
    public func stop() {
        player.stop()
    }
    
    func checkSubscriptionCapabilities() async throws {
        let subscription = try await MusicSubscription.current
        guard subscription.canPlayCatalogContent else {
            throw MusicServiceError.noActiveSubscription
        }
        
        #if os(visionOS) || os(iOS)
        canPlaySpatialAudio = audioSession.supportsMultichannelContent
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func deactivateAudioSession() async {
        #if os(visionOS) || os(iOS)
        do {
            try await audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session:", error)
        }
        #endif
    }
    
    public func queueAlbum(_ album: AlbumRepresentable) async throws {
        guard let musicKitAlbum = album as? MusicKitAlbum else {
            throw MusicServiceError.albumFetchFailed
        }
        
        let detailedAlbum = try await loadAlbumDetails(musicKitAlbum)
        guard let tracks = detailedAlbum.tracks else {
            throw MusicServiceError.albumFetchFailed
        }
        
        // Clear current queue
        if player.queue.entries.count > 0 {
            try await player.stop()
            // Create empty queue by setting it to empty array
            try await player.queue.insert([], position: .tail)
        }
        
        // Convert TrackRepresentable to MusicKit.Track for queue insertion
        let musicKitTracks = tracks.compactMap { track -> MusicKit.Track? in
            guard let musicKitTrack = track as? MusicKitTrack else { return nil }
            return musicKitTrack.musicKitTrack
        }
        
        // Add new tracks to queue
        try await player.queue.insert(musicKitTracks, position: .tail)
    }
    
    func clearQueue() async throws {
        if isPlaying {
            try await player.stop()
        }
        try await player.queue.insert([], position: .tail)
    }
    
    public func setQueue(for albums: [AlbumRepresentable]) async throws {
        guard let album = albums.first else { return }
        try await queueAlbum(album)
    }
}