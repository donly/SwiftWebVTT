// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftWebVTT",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "SwiftWebVTT", targets: [ "SwiftWebVTT" ]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftWebVTT", dependencies: [], path: "Sources"),
    ]
)
