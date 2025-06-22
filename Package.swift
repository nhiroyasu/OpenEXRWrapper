// swift-tools-version:5.10
import PackageDescription

let NAME = "OpenEXRWrapper"

let package = Package(
    name: NAME,
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        .library(name: NAME, targets: [NAME])
    ],
    targets: [
        .binaryTarget(
            name: NAME,
            url: "TODO",
            checksum: "90babf4d49e341f5d27976683fa8516ec01860c29ccb7aff5af7c9defab05e87"
        )
    ]
)