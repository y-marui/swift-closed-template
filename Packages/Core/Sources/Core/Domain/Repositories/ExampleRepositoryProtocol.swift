import Foundation

@MainActor
protocol ExampleRepositoryProtocol {
    func fetchItems() async throws -> [ExampleItem]
}
