import RealityKit

@available(visionOS 2.0, *)
struct ScrollComponent: Component {
    var axis: ScrollAxis
    var bounds: ClosedRange<Float>
    var speed: Float
    var currentOffset: Float = 0
    
    enum ScrollAxis {
        case horizontal
        case vertical
    }
} 