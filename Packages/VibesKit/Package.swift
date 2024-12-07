// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VibesKit",
    platforms: [
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "VibesKit",
            targets: ["VibesKit"]),
        .library(
            name: "PulsarSymphony",
            targets: ["PulsarSymphony"]),
        .library(
            name: "AetherParticles",
            targets: ["AetherParticles"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0")
    ],
    targets: [
        // Main umbrella module
        .target(
            name: "VibesKit",
            dependencies: [
                "PulsarSymphony",
                "AetherParticles",
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ]
        ),
        
        // Music service module
        .target(
            name: "PulsarSymphony",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ]
        ),
        
        // Particle system module
        .target(
            name: "AetherParticles",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        
        // Tests
        .testTarget(
            name: "VibesKitTests",
            dependencies: ["VibesKit"]
        ),
        .testTarget(
            name: "PulsarSymphonyTests",
            dependencies: ["PulsarSymphony"]
        ),
        .testTarget(
            name: "AetherParticlesTests",
            dependencies: ["AetherParticles"]
        )
    ]
)
