import Foundation

public struct ExampleItem: Identifiable, Decodable {
    public let id: UUID
    public let title: String
}
