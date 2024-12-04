import Foundation

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("RealityKitContent_RealityKitContent.bundle").path
        let buildPath = "/Users/jones/Documents/VisionOS apps/Vibes/Packages/RealityKitContent/.build/arm64-apple-macosx/debug/RealityKitContent_RealityKitContent.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            // Users can write a function called fatalError themselves, we should be resilient against that.
            Swift.fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}