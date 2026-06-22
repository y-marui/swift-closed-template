// swift-tools-version: 6.0
//
// NOTE: This Package.swift is for the Core library and tests only.
// iOSアプリのビルド・実行には .xcodeproj が必要です。
//
// Xcodeでプロジェクトを作成する手順:
//   1. Xcode > File > New > Project でiOS Appを作成
//   2. プロジェクト名を設定し、このディレクトリに保存
//   3. Xcode > File > Add Package Dependencies で Packages/Core を追加
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
