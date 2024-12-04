// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MusicService",
    platforms: [
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MusicService",
            targets: ["MusicService"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MusicService",
            dependencies: [],
            path: "Sources/MusicService"
        ),
        .testTarget(
            name: "MusicServiceTests",
            dependencies: ["MusicService"],
            path: "Tests/MusicServiceTests"
        ),
    ]
) 