// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VibesParticles",
    platforms: [
        .custom("visionOS", versionString: "2.0")
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
            dependencies: [],
            path: "Sources/VibesParticles"
        ),
        .testTarget(
            name: "VibesParticlesTests",
            dependencies: ["VibesParticles"],
            path: "Tests/VibesParticlesTests"
        ),
    ]
) 