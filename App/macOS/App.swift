import SwiftUI

@main
struct ExampleApp: App {

    private let dependency = AppDependency()

    var body: some Scene {
        WindowGroup {
            RootView(
                dependency: dependency,
                exampleViewModel: dependency.makeExampleViewModel()
            )
        }
    }
}
