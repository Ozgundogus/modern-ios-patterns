// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BrewCore",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "BrewDomain", targets: ["BrewDomain"]),
        .library(name: "BrewData", targets: ["BrewData"]),
    ],
    targets: [
        .target(name: "BrewDomain", path: "BrewDomain/Sources"),
        .testTarget(name: "BrewDomainTests", dependencies: ["BrewDomain"], path: "BrewDomain/Tests"),
        .target(
            name: "BrewData",
            dependencies: ["BrewDomain"],
            path: "BrewData/Sources",
            resources: [.process("Resources")]
        ),
        .testTarget(name: "BrewDataTests", dependencies: ["BrewData"], path: "BrewData/Tests"),
    ]
)
