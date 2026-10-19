// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ui",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.

        .library(
            name: "DoubleSide",
            targets: ["DoubleSide"]
        ),

    ],
    dependencies: [
        .package(url: "https://github.com/vitali-kurlovich/swift-mathkit.git", from: "0.16.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DoubleSide",
            dependencies: [
                .product(name: "CGMathKit", package: "swift-mathkit"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
