import Foundation

@MainActor
struct ExampleAPIRepository: ExampleRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchItems() async throws -> [ExampleItem] {
        try await apiClient.get(path: "/items")
    }
}
