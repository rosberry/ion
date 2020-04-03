// swift-tools-version:5.2
import PackageDescription
let package = Package(
    name: "Ion",
    platforms: [
        .iOS(.v10)
    ],
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
