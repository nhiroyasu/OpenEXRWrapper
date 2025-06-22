# OpenEXRWrapper

OpenEXRライブラリをSwiftプロジェクトに利用するためのラッパーライブラリ  
SwiftのARCや型安全な機能を活用し、EXRファイルを効率的に扱うためのモダンなインターフェースを提供します

## 特徴

- **Swift統合**: OpenEXRの機能をSwiftで直接利用可能。
- **型安全性**: Swiftの型安全な機能を活用。
- **自動参照カウント (ARC)**: メモリ管理を簡素化。
- **クロスプラットフォーム対応**: iOS、macOS、その他のAppleプラットフォームに対応。

## インストール

### Swift Package Manager
`Package.swift`ファイルに以下の依存関係を追加してください:

```swift
.package(url: "https://github.com/nhiroyasu/OpenEXRWrapper.git", from: "0.1.0")
```

## 使用方法

### EXRファイルの読み込み

```swift
import OpenEXRWrapper

let url = URL(fileURLWithPath: "path/to/your/file.exr")
do {
    let exrData = try readEXR(url: url)
    print("幅: \(exrData.header.width)")
    print("高さ: \(exrData.header.height)")
} catch {
    print("EXRファイルの読み込みに失敗しました: \(error)")
}
```

## 開発

このプロジェクトは、OpenEXRライブラリとそのラッパーをビルドするためにCMakeを使用しています。プラットフォーム固有のビルド設定については、`ios-cmake`フォルダを参照してください。

## ライセンス

このプロジェクトは、`LICENSE.md`ファイルに記載された条件に基づいています。
