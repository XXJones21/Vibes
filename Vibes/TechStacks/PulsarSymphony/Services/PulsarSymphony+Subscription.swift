import Foundation
import MusicKit
import AVFAudio

@available(visionOS 2.0, *)
extension PulsarSymphony {
    internal func checkSubscription() async throws {
        guard MusicAuthorization.currentStatus == .authorized else {
            throw PulsarError.noActiveSubscription
        }
    }
} 