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
            url: "https://github.com/nhiroyasu/OpenEXRWrapper/releases/download/try-publishing-xcframework/OpenEXRWrapper.xcframework.zip",
            checksum: "039509b39da702faab935252aa8deccd46b0138146b1d9bcb35f9acad4201a81"
        )
    ]
)