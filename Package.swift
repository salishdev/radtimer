// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "RadTimer",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "TimerFeature", targets: ["TimerFeature"]),
        .library(name: "SoundEffectClient", targets: ["SoundEffectClient"]),

    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TimerFeature",
            dependencies: [
                "SoundEffectClient",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "SoundEffectClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(name: "TimerFeatureTests", dependencies: ["TimerFeature"]),
    ]
)
