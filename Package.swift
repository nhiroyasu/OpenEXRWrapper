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
            url: "https://github.com/nhiroyasu/OpenEXRWrapper/releases/download/0.1.0/OpenEXRWrapper.xcframework.zip",
            checksum: "85493ad78b73014d706847ce6bc7d90e6b29ff0953085f02c14c51dbbbdf4f5b"
        )
    ]
)