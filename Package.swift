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
            checksum: "98bffaff446c0b3da73bf42707ac947eaebb29987888ca148855f08e58117a3f"
        )
    ]
)