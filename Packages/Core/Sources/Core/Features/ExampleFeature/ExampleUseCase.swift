import Foundation

// MARK: - Protocol

@MainActor
public protocol ExampleUseCaseProtocol {
    func fetchItems() async throws -> [ExampleItem]
}

// MARK: - Implementation

@MainActor
public struct ExampleUseCase: ExampleUseCaseProtocol {

    private let repository: ExampleRepositoryProtocol

    public init(repository: ExampleRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchItems() async throws -> [ExampleItem] {
        try await repository.fetchItems()
    }
}
