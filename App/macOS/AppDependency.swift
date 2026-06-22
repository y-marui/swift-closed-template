import Foundation

// MARK: - AppDependency
// Repository・UseCase・ViewModel はすべて @MainActor のため、
// ファクトリメソッドを @MainActor に統一する。

@MainActor
final class AppDependency {

    // MARK: - Infrastructure

    let apiClient: APIClientProtocol

    // MARK: - Repositories

    let exampleRepository: ExampleRepositoryProtocol

    // MARK: - Init

    init() {
        // ローカル優先: SwiftData を使う場合（推奨）
        // self.exampleRepository = ExampleLocalRepository(context: yourModelContext)

        // API を使う場合: baseURL を実際のエンドポイントに変更する
        guard let baseURL = URL(string: "https://api.example.com") else {
            fatalError("Invalid base URL. Update AppDependency.init() before running.")
        }
        self.apiClient = APIClient(baseURL: baseURL)
        self.exampleRepository = ExampleAPIRepository(apiClient: apiClient)
    }

    // MARK: - ViewModel Factories

    func makeExampleViewModel() -> ExampleViewModel {
        let useCase = ExampleUseCase(repository: exampleRepository)
        return ExampleViewModel(useCase: useCase)
    }
}
