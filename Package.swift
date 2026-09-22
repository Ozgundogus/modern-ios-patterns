// swift-tools-version: 6.0
import PackageDescription

/// Every pattern lives in `Patterns/<Name>/` with its own `Sources`, `Tests` and `README.md`.
let patterns = [
    "DependencyInjection",
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
