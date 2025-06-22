# OpenEXRWrapper

OpenEXRWrapper is a Swift wrapper for the OpenEXR library, enabling seamless integration of OpenEXR functionalities into Swift projects.  
This project leverages Swift's ARC and type-safe features to provide a modern and efficient interface for handling EXR files.

## Features

- **Swift Integration**: Utilize OpenEXR functionalities directly in Swift.
- **Type Safety**: Benefit from Swift's type-safe features.
- **Automatic Reference Counting (ARC)**: Simplify memory management.
- **Cross-Platform Support**: Compatible with iOS, macOS, and other Apple platforms.

## Installation

### Swift Package Manager
Add the following dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/your-repo/OpenEXRWrapper.git", from: "1.0.0")
```

## Usage

### Reading EXR Files

```swift
import OpenEXRWrapper

let url = URL(fileURLWithPath: "path/to/your/file.exr")
do {
    let exrData = try readEXR(url: url)
    print("Width: \(exrData.header.width)")
    print("Height: \(exrData.header.height)")
} catch {
    print("Failed to read EXR file: \(error)")
}
```

## Development

This project uses CMake for building the OpenEXR library and its wrapper. Refer to the `ios-cmake` folder for platform-specific build configurations.

## License

This project is licensed under the terms specified in the `LICENSE.md` file.
