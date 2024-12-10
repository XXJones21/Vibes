import RealityKit

/// Defines a sequence of animations for particle effects
@available(visionOS 2.0, *)
public struct AetherAnimationSequence {
    /// A single keyframe in the animation sequence
    public struct Keyframe {
        /// The time at which this keyframe occurs
        public let time: Double
        
        /// The value to animate to
        public let value: Value
        
        /// The possible values that can be animated
        public enum Value {
            /// Color transition
            case color(start: ParticleEmitterComponent.ParticleEmitter.Color, 
                      end: ParticleEmitterComponent.ParticleEmitter.Color)
            /// Position change
            case position(SIMD3<Float>)
            /// Scale change
            case scale(Float)
            /// Intensity change
            case intensity(Float)
        }
        
        public init(time: Double, value: Value) {
            self.time = time
            self.value = value
        }
    }
    
    /// The total duration of the sequence in seconds
    public let duration: Double
    
    /// Whether the sequence should repeat
    public let repeats: Bool
    
    /// The keyframes that make up this sequence
    public let keyframes: [Keyframe]
    
    public init(duration: Double, repeats: Bool = true, keyframes: [Keyframe]) {
        self.duration = duration
        self.repeats = repeats
        self.keyframes = keyframes
    }
} 