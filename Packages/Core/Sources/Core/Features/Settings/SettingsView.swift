import SwiftUI

public struct SettingsView: View {

    @AppStorage(AppLanguage.storageKey) private var language: AppLanguage = .system

    public init(store: UserDefaults) {
        _language = AppStorage(wrappedValue: .system, AppLanguage.storageKey, store: store)
    }

    public var body: some View {
        Form {
            Section {
                Picker("settings.language.title", bundle: .module, selection: $language) {
                    ForEach(AppLanguage.allCases) { option in
                        label(for: option).tag(option)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }

    @ViewBuilder
    private func label(for option: AppLanguage) -> some View {
        if let name = option.nativeName {
            Text(verbatim: name)
        } else {
            Text("settings.language.system", bundle: .module)
        }
    }
}
