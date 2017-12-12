// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "PerfectSquishy",
    products: [
        .library(
            name: "PerfectSquishy",
            targets: ["PerfectSquishy"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "sqparser",
            dependencies: []),
        .target(
            name: "PerfectSquishy",
            dependencies: ["sqparser"]),
        .testTarget(
            name: "PerfectSquishyTests",
            dependencies: ["PerfectSquishy"]),
    ]
)
