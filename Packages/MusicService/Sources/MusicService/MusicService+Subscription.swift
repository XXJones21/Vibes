import Foundation
import MusicKit
import AVFAudio
import RealityKit

extension VibesMusicService {
    func checkSubscriptionStatus() async throws {
        let subscription = try await MusicSubscription.current
        guard subscription.canPlayCatalogContent else {
            throw MusicServiceError.noActiveSubscription
        }
        
        // Check for spatial audio capability
        if #available(visionOS 1.0, *) {
            let audioSession = AVAudioSession.sharedInstance()
            
            // Check device spatial capabilities
            let deviceSupport = audioSession.currentRoute.outputs.contains { output in
                output.portType == .headphones || output.portType == .builtInSpeaker
            }
            
            canPlaySpatialAudio = deviceSupport && subscription.canPlayCatalogContent
            
            if !deviceSupport {
                throw MusicServiceError.headTrackingNotAvailable
            }
        } else {
            canPlaySpatialAudio = false
            throw MusicServiceError.spatialAudioNotAvailable
        }
    }
    
    private func configureSpatialAudio() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playback, mode: .moviePlayback)
        try audioSession.setActive(true)
    }
    
    func refreshSubscriptionStatus() async {
        do {
            try await checkSubscriptionStatus()
        } catch {
            self.error = error
            canPlaySpatialAudio = false
        }
    }
} 