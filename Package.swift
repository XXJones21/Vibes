// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Vibes",
    platforms: [
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "Vibes",
            targets: ["Vibes"])
    ],
    dependencies: [
        .package(path: "Packages/VibesKit")
    ],
    targets: [
        .target(
            name: "Vibes",
            dependencies: [
                .product(name: "VibesKit", package: "VibesKit"),
                .product(name: "PulsarSymphony", package: "VibesKit"),
                .product(name: "AetherParticles", package: "VibesKit")
            ]
        ),
        .testTarget(
            name: "VibesTests",
            dependencies: ["Vibes"])
    ]
) 