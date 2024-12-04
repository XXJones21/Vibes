import Foundation
import MusicKit
import AVFAudio

@available(visionOS 2.0, *)
extension VibesMusicService {
    internal func checkSubscription() async throws {
        let subscription = try await MusicSubscription.current
        guard subscription.canPlayCatalogContent else {
            throw MusicServiceError.noActiveSubscription
        }
    }
} 