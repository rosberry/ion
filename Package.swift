// swift-tools-version: 5.4
import PackageDescription
let package = Package(
    name: "Ion",
    platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v2)],
    products: [
        .library(
            name: "Ion",
            targets: ["Ion"]),
    ],
    targets: [
        .target(
            name: "Ion",
            path: "Common")
    ]
)
