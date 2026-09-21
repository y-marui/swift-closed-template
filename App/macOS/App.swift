import Core
import SwiftUI

@main
struct ExampleApp: App {

    private let dependency = AppDependency()

    @AppStorage(AppLanguage.storageKey, store: AppGroup.userDefaults) private var language: AppLanguage = .system

    var body: some Scene {
        WindowGroup {
            RootView(
                dependency: dependency,
                exampleViewModel: dependency.makeExampleViewModel()
            )
            .environment(\.locale, language.resolvedLocale)
        }

        Settings {
            SettingsView(store: AppGroup.userDefaults)
                .environment(\.locale, language.resolvedLocale)
        }
    }
}
