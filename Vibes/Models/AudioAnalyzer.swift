import Foundation
import AVFoundation
import Accelerate

// MARK: - Audio Analysis Data Structures
// TODO: Phase 2 - Expand AudioVisualizationData
// This structure will be enhanced to store comprehensive song analysis data:
// - MusicKit metadata and characteristics
// - Real-time frequency analysis
// - Beat detection and tempo mapping
// - Energy levels and dynamics
// - Section markers and transitions
// Will serve as the data bridge between PulsarSymphony and VibeEngine

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

class AudioAnalyzer: ObservableObject {
    private let engine = AVAudioEngine()
    private let bufferSize = 1024
    private var audioBuffer: [Float] = []
    private var fftSetup: vDSP_DFT_Setup?
    
    @Published var frequencyData: [Float] = Array(repeating: 0, count: 32)
    
    init() {
        setupEngine()
        fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Double(bufferSize))), Int32(FFT_RADIX2))
    }
    
    private func setupEngine() {
        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)
        
        input.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: format) { [weak self] buffer, time in
            guard let self = self else { return }
            let channelData = buffer.floatChannelData?[0]
            let frameLength = buffer.frameLength
            
            self.audioBuffer = Array(UnsafeBufferPointer(start: channelData, count: Int(frameLength)))
            self.processAudioData()
        }
        
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    private func processAudioData() {
        guard !audioBuffer.isEmpty else { return }
        
        let realPart = UnsafeMutablePointer<Float>.allocate(capacity: bufferSize)
        defer { realPart.deallocate() }
        
        let imagPart = UnsafeMutablePointer<Float>.allocate(capacity: bufferSize)
        defer { imagPart.deallocate() }
        
        // Copy audio data to real part
        audioBuffer.withUnsafeBufferPointer { bufferPointer in
            guard let baseAddress = bufferPointer.baseAddress else { return }
            realPart.initialize(from: baseAddress, count: bufferSize)
        }
        
        // Zero out imaginary part
        imagPart.initialize(repeating: 0, count: bufferSize)
        
        // Create split complex buffer
        var splitComplex = DSPSplitComplex(realp: realPart, imagp: imagPart)
        
        guard let fftSetup = fftSetup else { return }
        vDSP_fft_zrip(fftSetup, &splitComplex, 1, vDSP_Length(log2(Double(bufferSize))), Int32(FFT_FORWARD))
        
        // Process magnitude
        var magnitudes = [Float](repeating: 0, count: bufferSize/2)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(bufferSize/2))
        
        // Update frequency data on main thread
        let processedData = Array(magnitudes.prefix(32))
        DispatchQueue.main.async {
            self.frequencyData = processedData
        }
    }
    
    deinit {
        if let fftSetup = fftSetup {
            vDSP_destroy_fftsetup(fftSetup)
        }
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
    }
} 