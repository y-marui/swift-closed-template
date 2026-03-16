import SwiftUI

// @MainActorメソッドをinit内で呼ぶとコンパイルエラーになるため、
// ViewModel生成の責務はApp.swiftに置く。

struct RootView: View {

    private let dependency: AppDependency
    @State private var exampleViewModel: ExampleViewModel

    init(dependency: AppDependency, exampleViewModel: ExampleViewModel) {
        self.dependency = dependency
        self._exampleViewModel = State(initialValue: exampleViewModel)
    }

    var body: some View {
        NavigationStack {
            ExampleView(viewModel: exampleViewModel)
        }
    }
}
