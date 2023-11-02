// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// Package, library, target name
fileprivate let packageName = "KeychainHelper"
/// Test target name
fileprivate let testTargetName = packageName + "Tests"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: packageName,
            targets: [packageName]),
    ],
    targets: [
        .target(
            name: packageName),
        .testTarget(
            name: testTargetName,
            dependencies: [.init(stringLiteral: packageName)]),
    ]
)
