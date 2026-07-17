import Foundation

@MainActor
public protocol ExampleRepositoryProtocol {
    func fetchItems() async throws -> [ExampleItem]
}
