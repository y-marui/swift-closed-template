import Foundation

// MARK: - Protocol

@MainActor
protocol ExampleUseCaseProtocol {
    func fetchItems() async throws -> [ExampleItem]
}

// MARK: - Implementation

@MainActor
struct ExampleUseCase: ExampleUseCaseProtocol {

    private let repository: ExampleRepositoryProtocol

    init(repository: ExampleRepositoryProtocol) {
        self.repository = repository
    }

    func fetchItems() async throws -> [ExampleItem] {
        try await repository.fetchItems()
    }
}
