import SwiftUI

public struct ExampleView: View {

    @State private var viewModel: ExampleViewModel

    public init(viewModel: ExampleViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
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
                ContentUnavailableView {
                    Label {
                        Text("common.error.title", bundle: .module)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle")
                    }
                } description: {
                    Text(message)
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            Task { await viewModel.refresh() }
                        } label: {
                            Text("common.retry", bundle: .module)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("example.title", bundle: .module))
        .task {
            await viewModel.onAppear()
        }
    }
}
