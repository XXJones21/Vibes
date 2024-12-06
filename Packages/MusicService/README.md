# MusicService

A Swift package for integrating Apple Music functionality in visionOS apps, providing a clean interface for music playback and library management.

## Features

- Apple Music integration
- Album browsing and management
- Playback control
- Artwork handling
- Spatial audio support
- Category-based organization
- Efficient caching system

## Requirements

- visionOS 2.0+
- Swift 5.9+
- MusicKit

## Package Structure

```
MusicService/
├── Sources/
│   └── MusicService/
│       ├── Models/          # Data models and types
│       ├── MusicService.swift       # Core service
│       ├── MusicService+Albums.swift # Album management
│       ├── MusicService+Debug.swift  # Debug utilities
│       ├── MusicService+Pagination.swift # Pagination
│       ├── MusicService+Setup.swift     # Setup
│       ├── MusicService+Subscription.swift # Subscription
│       └── Types.swift      # Core types and protocols
└── Tests/                  # Unit tests
```

## Usage

### Basic Setup

```swift
import MusicService

// Initialize the service
let musicService = MusicService()

// Request authorization
try await musicService.requestAuthorization()

// Check subscription status
let isSubscribed = try await musicService.verifySubscription()
```

### Album Management

```swift
// Fetch albums by category
let albums = try await musicService.fetchAlbums(category: .recentlyAdded)

// Get album artwork
let artwork = try await albums.first?.artwork(size: CGSize(width: 300, height: 300))
```

### Playback Control

```swift
// Start playback
try await musicService.play(album: selectedAlbum)

// Control playback
musicService.pause()
musicService.resume()
musicService.skipToNext()
```

## Album Categories

- `.recentlyAdded`
- `.recentlyPlayed`
- `.favorites`
- `.heavyRotation`

## Implementation Notes

- Uses MusicKit for Apple Music integration
- Implements efficient caching for albums and artwork
- Provides proper error handling
- Supports spatial audio configuration
- Manages authorization and subscription status

## License

This package is part of the Vibes project. 