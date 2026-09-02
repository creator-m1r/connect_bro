// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ConnectBro",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "ConnectBro", targets: ["ConnectBro"])
    ],
    targets: [
        .executableTarget(
            name: "ConnectBro",
            path: "Sources/ConnectBro"
        ),
        .testTarget(
            name: "ConnectBroTests",
            dependencies: ["ConnectBro"],
            path: "Tests/ConnectBroTests"
        )
    ]
)
