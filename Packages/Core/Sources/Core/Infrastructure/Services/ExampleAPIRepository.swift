import Foundation

@MainActor
public struct ExampleAPIRepository: ExampleRepositoryProtocol {

    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func fetchItems() async throws -> [ExampleItem] {
        try await apiClient.get(path: "/items")
    }
}
