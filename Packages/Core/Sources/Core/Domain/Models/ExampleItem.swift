import Foundation

struct ExampleItem: Identifiable, Decodable {
    let id: UUID
    let title: String
}
