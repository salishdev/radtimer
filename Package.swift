// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "RadTimer",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(name: "TimerFeature", targets: ["TimerFeature"]),

    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "TimerFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(name: "TimerFeatureTests", dependencies: ["TimerFeature"]),
    ]
)
