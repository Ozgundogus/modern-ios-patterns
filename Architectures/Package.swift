// swift-tools-version: 6.0
import PackageDescription

let strict: [SwiftSetting] = [.unsafeFlags(["-warnings-as-errors"])]

let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")

let brew: [Target.Dependency] = [
    .product(name: "BrewDomain", package: "Core"),
    .product(name: "BrewData", package: "Core"),
]

func architecture(_ name: String, path: String? = nil, dependencies: [Target.Dependency] = []) -> [Target] {
    let path = path ?? name
    return [
        .target(
            name: name,
            dependencies: brew + ["BrewUI"] + dependencies,
            path: "\(path)/Sources",
            swiftSettings: strict
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [.target(name: name)] + brew + dependencies,
            path: "\(path)/Tests",
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
        .library(name: "MVVMCSwiftUI", targets: ["MVVMCSwiftUI"]),
        .library(name: "MVVMCUIKit", targets: ["MVVMCUIKit"]),
        .library(name: "MVVMCHybrid", targets: ["MVVMCHybrid"]),
        .library(name: "MVVMR", targets: ["MVVMR"]),
        .library(name: "Clean", targets: ["Clean"]),
        .library(name: "MVC", targets: ["MVC"]),
        .library(name: "VIPER", targets: ["VIPER"]),
        .library(name: "TCA", targets: ["TCA"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.0"),
    ],
    targets: [
        .target(name: "BrewUI", dependencies: brew, path: "BrewUI/Sources", swiftSettings: strict),
    ]
        + architecture("MVVM")
        + architecture("MVVMCViewModels", path: "MVVMC/ViewModels")
        + architecture("MVVMCSwiftUI", path: "MVVMC/SwiftUI", dependencies: ["MVVMCViewModels"])
        + architecture("MVVMCUIKit", path: "MVVMC/UIKit", dependencies: ["MVVMCViewModels"])
        + architecture("MVVMCHybrid", path: "MVVMC/Hybrid", dependencies: ["MVVMCViewModels", "MVVMCUIKit", "MVVMCSwiftUI"])
        + architecture("MVVMR")
        + architecture("Clean")
        + architecture("MVC")
        + architecture("VIPER")
        + architecture("TCA", dependencies: [tca])
)
