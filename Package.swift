// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "RadialTimer",
    platforms: [.macOS(.v13)],
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
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.3.0"),
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
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
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
