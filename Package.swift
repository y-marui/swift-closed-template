// swift-tools-version: 6.0
//
// NOTE: This Package.swift is for the Core library and tests only.
// iOSアプリのビルド・実行には .xcodeproj が必要です。
//
// Xcodeプロジェクトは `xcodegen generate` で project.yml から生成します。
//
// ライブラリ・テストのみ手元で動かす場合:
//   cd Packages/Core && swift test

import PackageDescription

let package = Package(
    name: "SwiftAIAppTemplate",
    platforms: [.iOS(.v17), .macOS(.v14)],
    dependencies: [
        .package(path: "Packages/Core")
    ],
    targets: []
)
