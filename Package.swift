// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Game",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Game",
                 type: .dynamic,
                 targets: ["Game"])
    ],
    dependencies: [
        .package(url: "https://github.com/Codetoil/MMHMSSE", revision: "78a8420a840a34970003b2dfd668b30b86e65838"),
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "7c34297bc676b37dbb7b0a53c2d334aa2a1bfcdf")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies
        .target(
            name: "Game",
            dependencies: ["MMHMSSE", "SwiftGodot"],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])]),
        .testTarget(
            name: "GameTests",
            dependencies: ["Game"])
    ]
)
