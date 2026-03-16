import SwiftUI

struct ExampleView: View {

    @State private var viewModel: ExampleViewModel

    init(viewModel: ExampleViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear

            case .loading:
                ProgressView()

            case .loaded(let items), .refreshing(let items):
                List(items) { item in
                    Text(item.title)
                }
                .refreshable {
                    await viewModel.refresh()
                }

            case .error(let message):
                ContentUnavailableView(
                    String(localized: "common.error.title"),
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(String(localized: "common.retry")) {
                            Task { await viewModel.refresh() }
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "example.title"))
        .task {
            await viewModel.onAppear()
        }
    }
}
