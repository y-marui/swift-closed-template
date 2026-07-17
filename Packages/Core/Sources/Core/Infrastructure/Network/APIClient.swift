import Foundation

// MARK: - Protocol

@MainActor
public protocol APIClientProtocol {
    func get<T: Decodable>(path: String) async throws -> T
}

// MARK: - Implementation

@MainActor
public struct APIClient: APIClientProtocol {

    public let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func get<T: Decodable>(path: String) async throws -> T {
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
