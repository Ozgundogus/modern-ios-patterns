#if canImport(SwiftUI)
import SwiftUI

struct OfflineSyncPlayground: View {
    @State private var server = InMemoryTodoServer(latency: .milliseconds(400))
    @State private var isOnline = true
    @State private var viewModel: TodoListViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    TodoListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Offline-first")
            .toolbar {
                ToolbarItem {
                    Toggle("Online", isOn: $isOnline)
                }
                ToolbarItem {
                    Button("Edit from another device") {
                        Task {
                            await server.editFromAnotherDevice(
                                TodoItem(title: "Added on iPad", createdAt: .now)
                            )
                            await viewModel?.sync()
                        }
                    }
                }
            }
        }
        .task {
            let store = LocalStore()
            viewModel = TodoListViewModel(store: store, engine: SyncEngine(store: store, server: server))
        }
        .onChange(of: isOnline) { _, online in
            Task {
                await server.setReachable(online)
                if online { await viewModel?.sync() }
            }
        }
    }
}

#Preview("Playground") {
    OfflineSyncPlayground()
}
#endif
