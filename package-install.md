# MusicService Package Installation Guide

## 1. Remove Old Implementation

Delete file: 
`Vibes/Services/MusicService.swift`
startLine: 1
endLine: 35


## 2. Update Package Dependencies

Add to your app's Package.swift:

```swift
dependencies: [
.package(path: "Packages/MusicService")
]
```


## 3. Update App Code

### a. Import Package
Add to files that used the old MusicService:

`import MusicService`


### b. Replace Service Instantiation
Replace existing MusicService instantiation with:

`@StateObject private var musicService = VibesMusicService()`


## Package Features

The new package implementation provides:
- Full MusicProviding protocol implementation
- Error handling
- Audio session management
- Subscription checks
- Spatial audio support
- Queue management
- State management with observers

## Package Structure

Core files:
```swift
Packages/MusicService/.build/arm64-apple-macosx/debug/MusicService.build/sources
startLine: 1
endLine: 5
```


## Platform Support
- visionOS 1.0+

## Dependencies
- MusicKit
- AVFAudio
- SwiftUI
- AVFoundation

For more details about the package structure and future plans, see:

```swift
markdown:package-structure.md
startLine: 1
endLine: 59
```