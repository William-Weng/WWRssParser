// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWRssParser",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWRssParser", targets: ["WWRssParser"]),
    ],
    targets: [
        .target(name: "WWRssParser"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
