// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "covid-analyzer",
    products: [
        .library(name: "covid-analyzer", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.5.6")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "SwiftCSV"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

