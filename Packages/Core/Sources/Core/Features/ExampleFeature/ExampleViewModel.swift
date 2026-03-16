import Foundation

@MainActor
@Observable
final class ExampleViewModel {

    enum ViewState {
        case idle
        case loading
        case loaded([ExampleItem])
        case refreshing([ExampleItem])
        case error(String)
    }

    private(set) var state: ViewState = .idle

    private let useCase: ExampleUseCaseProtocol

    init(useCase: ExampleUseCaseProtocol) {
        self.useCase = useCase
    }

    func onAppear() async {
        guard case .idle = state else { return }
        await load()
    }

    func refresh() async {
        if case .loaded(let current) = state {
            state = .refreshing(current)
        }
        await load()
    }

    private func load() async {
        if case .idle = state { state = .loading }
        do {
            let items = try await useCase.fetchItems()
            state = .loaded(items)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
