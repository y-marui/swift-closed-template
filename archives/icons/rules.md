# アイコン管理規則

このディレクトリにはアイコンの**過去バージョン**を保管する。
現行アイコンは `Resources/Assets.xcassets/AppIcon.appiconset/` に置く。

## File Naming Convention

```
icon-v1.png          # アプリアイコン バージョン1
icon-v2.png          # アプリアイコン バージョン2
icon-menubar-v1.png  # メニューバーアイコン バージョン1（macOS のみ）
icon-menubar-v2.png  # メニューバーアイコン バージョン2
```

バージョン番号はデザインを大きく変えたタイミングで上げる。
マイナーな調整は同じバージョン番号のまま上書きする。

## Recommended Sizes

| 用途 | サイズ |
|---|---|
| アプリアイコン（書き出し元） | 1024×1024 px |
| メニューバーアイコン（書き出し元） | 44×44 px（@2x: 88×88 px） |

## Notes

- 制作データ（Figma・Sketch 等）はこのディレクトリには置かない
- アイコンを更新したら古いバージョンをここに移動してからコミットする
