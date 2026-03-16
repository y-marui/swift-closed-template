# Feature Example: TodoList

`ExampleFeature` を参考に、実際のフィーチャーを追加する手順を示します。
ここでは「TodoList（タスク一覧）」フィーチャーを例に説明します。

## 完成後のファイル構成

```
Packages/Core/Sources/Core/
├── Domain/
│   ├── Models/
│   │   └── Todo.swift                    # Domainモデル
│   └── Repositories/
│       └── TodoRepositoryProtocol.swift  # Repositoryプロトコル
├── Features/
│   └── TodoList/
│       ├── TodoListView.swift            # View
│       ├── TodoListViewModel.swift       # ViewModel
│       └── TodoListUseCase.swift         # UseCase
└── Infrastructure/
    └── Services/
        └── TodoRepository.swift          # Repository実装
```

---

## Step 1: Domain モデルを定義する

`Domain/Models/Todo.swift`

```swift
import Foundation

// ✅ pure Swift struct — framework の import なし
struct Todo: Identifiable {
    let id: UUID
    var title: String
    var isDone: Bool
    let createdAt: Date
}
```

---

## Step 2: Repository プロトコルを定義する

`Domain/Repositories/TodoRepositoryProtocol.swift`

```swift
import Foundation

// ✅ プロトコルは Domain に置く
// ✅ 実装は Infrastructure に置く（このファイルには書かない）
@MainActor
protocol TodoRepositoryProtocol {
    func fetchAll() async throws -> [Todo]
    func save(_ todo: Todo) async throws
    func delete(id: UUID) async throws
}
```

---

## Step 3: UseCase を定義する

`Features/TodoList/TodoListUseCase.swift`

```swift
import Foundation

@MainActor
protocol TodoListUseCaseProtocol {
    func fetchTodos() async throws -> [Todo]
    func addTodo(title: String) async throws
    func toggleDone(_ todo: Todo) async throws
}

@MainActor
struct TodoListUseCase: TodoListUseCaseProtocol {

    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func fetchTodos() async throws -> [Todo] {
        try await repository.fetchAll()
    }

    func addTodo(title: String) async throws {
        let todo = Todo(id: UUID(), title: title, isDone: false, createdAt: Date())
        try await repository.save(todo)
    }

    func toggleDone(_ todo: Todo) async throws {
        var updated = todo
        updated.isDone.toggle()
        try await repository.save(updated)
    }
}
```

---

## Step 4: ViewModel を定義する

`Features/TodoList/TodoListViewModel.swift`

```swift
import Foundation

@MainActor
@Observable
final class TodoListViewModel {

    enum ViewState {
        case idle
        case loading
        case loaded([Todo])
        case refreshing([Todo])
        case error(String)
    }

    private(set) var state: ViewState = .idle
    private let useCase: TodoListUseCaseProtocol

    init(useCase: TodoListUseCaseProtocol) {
        self.useCase = useCase
    }

    func onAppear() async {
        guard case .idle = state else { return }
        await load()
    }

    func refresh() async {
        if case .loaded(let current) = state {
            state = .refreshing(current)
        }
        await load()
    }

    func addTodo(title: String) async {
        do {
            try await useCase.addTodo(title: title)
            await refresh()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func load() async {
        if case .idle = state { state = .loading }
        do {
            let todos = try await useCase.fetchTodos()
            state = .loaded(todos)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
```

---

## Step 5: View を定義する

`Features/TodoList/TodoListView.swift`

```swift
import SwiftUI

struct TodoListView: View {

    @State private var viewModel: TodoListViewModel
    @State private var newTitle = ""

    init(viewModel: TodoListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
            case .loading:
                ProgressView()
            case .loaded(let todos), .refreshing(let todos):
                List(todos) { todo in
                    Text(todo.title)
                        .strikethrough(todo.isDone)
                }
                .refreshable { await viewModel.refresh() }
            case .error(let message):
                ContentUnavailableView(
                    String(localized: "common.error.title"),
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        }
        .navigationTitle(String(localized: "todo.list.title"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(String(localized: "todo.add.button")) {
                    Task { await viewModel.addTodo(title: String(localized: "todo.new.placeholder")) }
                }
            }
        }
        .task { await viewModel.onAppear() }
    }
}
```

---

## Step 6: Repository 実装を追加する

`Infrastructure/Services/TodoRepository.swift`

```swift
import Foundation

// API ベースの場合
struct TodoAPIRepository: TodoRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchAll() async throws -> [Todo] {
        // let dtos: [TodoDTO] = try await apiClient.get(path: "/todos")
        // return dtos.map { $0.toDomain() }
        return []
    }

    func save(_ todo: Todo) async throws {
        // try await apiClient.post(path: "/todos", body: TodoDTO(from: todo))
    }

    func delete(id: UUID) async throws {
        // try await apiClient.delete(path: "/todos/\(id)")
    }
}
```

---

## Step 7: AppDependency に登録する

`App/AppDependency.swift`

```swift
// Repositories セクションに追加
let todoRepository: TodoRepositoryProtocol

// init() 内に追加
self.todoRepository = TodoAPIRepository(apiClient: apiClient)

// ViewModel Factories セクションに追加
@MainActor
func makeTodoListViewModel() -> TodoListViewModel {
    TodoListViewModel(useCase: TodoListUseCase(repository: todoRepository))
}
```

---

## Step 8: RootView に追加する

```swift
NavigationStack {
    TodoListView(viewModel: dependency.makeTodoListViewModel())
}
```

---

## よくある間違い

| ❌ やってはいけない | ✅ 正しい |
|---|---|
| `ViewModel` 内で `APIClient` を直接呼ぶ | `UseCase` 経由で呼ぶ |
| `Domain` モデルに `import SwiftData` を書く | `Infrastructure` 層でのみ使う |
| `View` 内にビジネスロジックを書く | `UseCase` に移動する |
| `@StateObject` / `ObservableObject` を使う | `@Observable` + `@State` を使う |
| `DispatchQueue` / Combine を使う | `async/await` + `.task` を使う |
