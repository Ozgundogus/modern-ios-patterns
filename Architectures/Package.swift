// swift-tools-version: 6.0
import PackageDescription

let strict: [SwiftSetting] = [.unsafeFlags(["-warnings-as-errors"])]

let brew: [Target.Dependency] = [
    .product(name: "BrewDomain", package: "Core"),
    .product(name: "BrewData", package: "Core"),
]

func architecture(_ name: String, dependencies: [Target.Dependency] = []) -> [Target] {
    [
        .target(
            name: name,
            dependencies: brew + ["BrewUI"] + dependencies,
            path: "\(name)/Sources",
            swiftSettings: strict
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [.target(name: name)] + brew,
            path: "\(name)/Tests",
            swiftSettings: strict
        ),
    ]
}

let package = Package(
    name: "BrewArchitectures",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "BrewUI", targets: ["BrewUI"]),
        .library(name: "MVVM", targets: ["MVVM"]),
        .library(name: "MVVMC", targets: ["MVVMC"]),
        .library(name: "MVVMR", targets: ["MVVMR"]),
        .library(name: "Clean", targets: ["Clean"]),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "BrewUI", dependencies: brew, path: "BrewUI/Sources", swiftSettings: strict),
    ]
        + architecture("MVVM")
        + architecture("MVVMC")
        + architecture("MVVMR")
        + architecture("Clean")
)
