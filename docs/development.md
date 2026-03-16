# 開発ガイド

## セットアップ

```bash
git clone <repo>
cd <repo>
make bootstrap
```

## 日常コマンド

| コマンド | 説明 |
|---|---|
| `make lint` | SwiftLint を実行 |
| `make format` | SwiftFormat を実行 |
| `make test` | 全テストを実行 |
| `make clean` | ビルド成果物を削除 |

## 新規フィーチャーの追加

1. ディレクトリを作成する：
   ```
   Packages/Core/Sources/Core/Features/MyFeature/
   ```

2. テンプレートをコピーする：
   ```bash
   cp templates/feature/View.swift.template Packages/Core/Sources/Core/Features/MyFeature/MyFeatureView.swift
   cp templates/feature/ViewModel.swift.template Packages/Core/Sources/Core/Features/MyFeature/MyFeatureViewModel.swift
   cp templates/feature/UseCase.swift.template Packages/Core/Sources/Core/Features/MyFeature/MyFeatureUseCase.swift
   ```

3. `{{FeatureName}}` をフィーチャー名に置き換える。

4. `Domain/Models/` に Domain モデルを追加する。

5. `Domain/Repositories/` に Repository プロトコルを追加する。

6. `Infrastructure/Services/` に Repository 実装を追加する。

7. `AppDependency.swift` に登録する：
   ```swift
   func makeMyFeatureViewModel() -> MyFeatureViewModel {
       MyFeatureViewModel(useCase: MyFeatureUseCase(repository: myRepository))
   }
   ```

## テスト

- Unit テストは `Packages/Core/Tests/CoreTests/` に置く
- 依存はプロトコル経由でモックする
- Given / When / Then 構造で書く

```swift
func test_onAppear_loadsItems() async {
    // Given
    let mock = MockUseCase(result: .success([...]))
    let sut = MyViewModel(useCase: mock)

    // When
    await sut.onAppear()

    // Then
    XCTAssertEqual(...)
}
```
