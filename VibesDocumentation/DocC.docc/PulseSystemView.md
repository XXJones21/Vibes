# ``PulseSystemView``

A SwiftUI view for displaying particle effects.

@Metadata {
    @Available(visionOS, introduced: "1.0")
    @DisplayName("Pulse System View")
}

## Overview

``PulseSystemView`` provides a SwiftUI interface for displaying and managing particle effects. It handles the integration between RealityKit's particle system and SwiftUI's view system.

```swift
struct ContentView: View {
    var body: some View {
        PulseSystemView(effects: [
            FirefliesEffect(preset: .fireflies),
            GalaxyEffect(preset: .galaxy)
        ], maxEffects: 5)
    }
}
```

## Topics

### Essentials

- ``init(effects:maxEffects:)``
- ``addEffect(_:)``
- ``removeEffect(_:)``
- ``removeAllEffects()``

### Performance

- ``performanceMetrics``
- ``detailedMetrics``

## Using PulseSystemView

Create a view with initial effects:

```swift
// Create view with initial effects
let view = PulseSystemView(effects: [
    FirefliesEffect(),
    GalaxyEffect()
])

// Add effects dynamically
view.addEffect(FirefliesEffect(preset: .fireflies))

// Monitor performance
let (activeCount, avgFPS) = view.performanceMetrics
```

### Layout Management

The view automatically handles effect layout:

```swift
struct VisualizerView: View {
    var body: some View {
        PulseSystemView(effects: [
            FirefliesEffect(),
            GalaxyEffect()
        ])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}
```

### Performance Monitoring

Monitor view performance in real-time:

```swift
let metrics = view.detailedMetrics
print("Active Effects: \(metrics.activeEffects)")
print("Average FPS: \(metrics.averageFrameRate)")
print("Average Update Time: \(metrics.averageUpdateTime)ms")
```

### Effect Management

Manage effects dynamically:

```swift
// Add new effect
let effect = FirefliesEffect()
view.addEffect(effect)

// Remove specific effect
view.removeEffect(effect)

// Remove all effects
view.removeAllEffects()
```

## Performance Guidelines

For optimal performance:
- Limit the number of simultaneous effects
- Monitor frame rates
- Remove unused effects
- Use appropriate view sizes

## See Also

- ``PulseParticles``
- ``PulseEffect``
- ``FirefliesEffect``
- ``GalaxyEffect`` 