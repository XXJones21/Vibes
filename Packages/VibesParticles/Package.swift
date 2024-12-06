// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VibesParticles",
    platforms: [
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "VibesParticles",
            targets: ["VibesParticles"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "VibesParticles",
            dependencies: []),
        .testTarget(
            name: "VibesParticlesTests",
            dependencies: ["VibesParticles"]),
    ]
) 