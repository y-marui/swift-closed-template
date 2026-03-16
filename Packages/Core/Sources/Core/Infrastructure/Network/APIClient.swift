import Foundation

// MARK: - Protocol

@MainActor
protocol APIClientProtocol {
    func get<T: Decodable>(path: String) async throws -> T
}

// MARK: - Implementation

@MainActor
struct APIClient: APIClientProtocol {

    let baseURL: URL

    func get<T: Decodable>(path: String) async throws -> T {
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
