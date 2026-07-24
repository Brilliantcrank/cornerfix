// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CornerFix",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "CornerFix",
            path: "Sources/CornerFix"
        )
    ]
)
