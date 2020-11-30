// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "Ion",
        platforms: [.iOS(.v12)],
        products: [
            .library(name: "Ion", targets: ["Ion"])
        ],
        targets: [
            .target(name: "Ion",
                    path: "Common"),
        ]
)
