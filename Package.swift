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
            url: "https://github.com/nhiroyasu/OpenEXRWrapper/releases/download/0.1.1/OpenEXRWrapper.xcframework.zip",
            checksum: "981745f4d7aab41bdb2e93db9cdfb047585c23be0d95a46a0116baace4a96ea4"
        )
    ]
)