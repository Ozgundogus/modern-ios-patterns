// swift-tools-version: 6.0
import PackageDescription

let patterns = [
    "DependencyInjection",
    "DIContainer",
    "Repository",
    "Coordinator",
    "FeatureFlags",
    "OfflineSync",
]

let package = Package(
    name: "ModernIOSPatterns",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: patterns.map { .library(name: $0, targets: [$0]) },
    targets: patterns.flatMap { name in
        [
            .target(name: name, path: "Patterns/\(name)/Sources"),
            .testTarget(
                name: "\(name)Tests",
                dependencies: [.target(name: name)],
                path: "Patterns/\(name)/Tests"
            ),
        ]
    }
)
