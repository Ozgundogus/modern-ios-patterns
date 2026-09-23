// swift-tools-version: 6.0
import PackageDescription

let patterns = [
    "DependencyInjection",
    "DIContainer",
    "Repository",
    "Coordinator",
    "FeatureFlags",
    "OfflineSync",
    "Adapter",
    "Factory",
    "Builder",
    "Strategy",
    "Decorator",
    "Facade",
    "Observer",
    "StateMachine",
    "ResultBuilder",
    "Singleton",
]

let patternTargets: [Target] = patterns.flatMap { name in
    [
        .target(name: name, path: "Patterns/\(name)/Sources"),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [.target(name: name)],
            path: "Patterns/\(name)/Tests"
        ),
    ]
}

let package = Package(
    name: "ModernIOSPatterns",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: patterns.map { .library(name: $0, targets: [$0]) },
    targets: patternTargets
)
