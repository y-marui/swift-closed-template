import SwiftUI

// `String(localized:)` は環境の `locale`（アプリ内の言語設定）を無視する。
// 標準の SwiftUI イニシャライザはバンドルを指定できないため、Core のカタログ（`Bundle.module`）を引く
// `Text(_, bundle:)` に委譲するイニシャライザを用意する。

extension Button where Label == Text {
    init(_ key: LocalizedStringKey, bundle: Bundle, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.init(role: role, action: action) { Text(key, bundle: bundle) }
    }
}

extension Label where Title == Text, Icon == Image {
    init(_ key: LocalizedStringKey, bundle: Bundle, systemImage: String) {
        self.init { Text(key, bundle: bundle) } icon: { Image(systemName: systemImage) }
    }
}

extension Section where Parent == Text, Content: View, Footer == EmptyView {
    init(_ key: LocalizedStringKey, bundle: Bundle, @ViewBuilder content: () -> Content) {
        self.init(content: content) { Text(key, bundle: bundle) }
    }
}

extension Picker where Label == Text {
    init(
        _ key: LocalizedStringKey,
        bundle: Bundle,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) {
        self.init(selection: selection, content: content) { Text(key, bundle: bundle) }
    }
}

extension Toggle where Label == Text {
    init(_ key: LocalizedStringKey, bundle: Bundle, isOn: Binding<Bool>) {
        self.init(isOn: isOn) { Text(key, bundle: bundle) }
    }
}

extension TextField where Label == Text {
    init(_ key: LocalizedStringKey, bundle: Bundle, text: Binding<String>) {
        self.init(text: text) { Text(key, bundle: bundle) }
    }
}

extension ProgressView where Label == Text, CurrentValueLabel == EmptyView {
    init(_ key: LocalizedStringKey, bundle: Bundle) {
        self.init { Text(key, bundle: bundle) }
    }
}
