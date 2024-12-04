import Foundation
import AVFAudio
import MusicKit

extension VibesMusicService {
    func setupAudioSession() async throws {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            // Basic configuration for playback
            try await audioSession.setCategory(.playback, mode: .default)
            try await audioSession.setActive(true)
            
            // Configure audio engine
            try await configureAudioEngine()
            
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
            throw MusicServiceError.audioSessionSetupFailed(error)
        }
    }
    
    private func configureAudioEngine() async throws {
        guard !audioEngine.isRunning else { return }
        
        do {
            // Basic configuration
            let mainMixer = audioEngine.mainMixerNode
            mainMixer.outputVolume = 1.0
            try audioEngine.start()
        } catch {
            print("Failed to configure audio engine: \(error.localizedDescription)")
            throw MusicServiceError.audioEngineSetupFailed(error)
        }
    }
    
    func cleanup() async {
        // Stop audio engine if running
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        
        do {
            // Deactivate audio session
            try await AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to cleanup audio session:", error.localizedDescription)
        }
    }
} 