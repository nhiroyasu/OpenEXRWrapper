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
            url: "https://github.com/nhiroyasu/OpenEXRWrapper/releases/download/0.1.2/OpenEXRWrapper.xcframework.zip",
            checksum: "cc760ae1056712e5bde4cace6d71bf8139f7aa9f5b73707448b60000c68739c6"
        )
    ]
)