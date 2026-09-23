import Testing
@testable import OfflineSync

@MainActor
struct TodoListViewModelTests {
    @Test func addShowsTheItemEvenWhenOffline() async {
        let store = LocalStore()
        let server = InMemoryTodoServer()
        await server.setReachable(false)
        let viewModel = TodoListViewModel(store: store, engine: SyncEngine(store: store, server: server))

        await viewModel.add("Buy milk")

        #expect(viewModel.items.map(\.title) == ["Buy milk"])
        #expect(viewModel.pendingChanges == 1)
        #expect(viewModel.status == .offline)
    }

    @Test func comingBackOnlineSyncsPendingChanges() async {
        let store = LocalStore()
        let server = InMemoryTodoServer()
        await server.setReachable(false)
        let viewModel = TodoListViewModel(store: store, engine: SyncEngine(store: store, server: server))
        await viewModel.add("Buy milk")

        await server.setReachable(true)
        await viewModel.syncWhenOnline(StubConnectivityMonitor(values: [false, true]))

        #expect(viewModel.pendingChanges == 0)
        #expect(viewModel.status == .synced)
        #expect(await server.items.count == 1)
    }
}
