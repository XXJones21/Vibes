# PulsarSymphony

A visionOS-optimized music service module that provides spatial audio playback and music catalog browsing capabilities through MusicKit integration.

## Features

- Spatial Audio Support
- Music Catalog Integration
- Album Category Management
- Pagination Support
- Debug Utilities

## Structure

```
PulsarSymphony/
├── Models/
│   ├── MusicKitWrappers.swift   # Protocol definitions and MusicKit wrappers
│   └── Types.swift              # Core type definitions
└── Services/
    ├── PulsarSymphony.swift           # Main service implementation
    ├── PulsarSymphony+Albums.swift    # Album management
    ├── PulsarSymphony+Debug.swift     # Debug utilities
    ├── PulsarSymphony+Pagination.swift # Pagination handling
    └── PulsarSymphony+Subscription.swift # Subscription management
```

## Usage

```swift
@MainActor
class YourViewModel: ObservableObject {
    private let pulsar = PulsarSymphony()
    
    func loadAlbums() async throws {
        try await pulsar.checkAuthorization()
        let albums = try await pulsar.fetchAlbums(category: .spatial)
        // Handle albums...
    }
}
```

## Categories

- Recently Played
- Top Charts
- New Releases
- Spatial Audio
- Editor's Picks

## Requirements

- visionOS 2.0+
- MusicKit
- Active Apple Music subscription for full functionality

## Notes

- All music playback is optimized for spatial audio
- Album cache is maintained for performance
- Pagination is supported for large collections
