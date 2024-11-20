// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTGSDKSwift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MTGSDKSwift",
            targets: ["MTGSDKSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MTGSDKSwift",
            dependencies: [],
            path: "MTGSDKSwift"
        ),
        .testTarget(
            name: "MTGSDKSwiftTests",
            dependencies: [],
            path: "MTGSDKSwiftTests"
        ),
    ]
)
