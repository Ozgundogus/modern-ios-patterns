import Testing
@testable import OfflineSync

struct SyncEngineReentrancyTests {
    @Test func concurrentSyncCallsShareOneRequest() async throws {
        let store = LocalStore()
        let server = InMemoryTodoServer(latency: .milliseconds(100))
        let engine = SyncEngine(store: store, server: server)
        await store.apply(.upsert(TodoItem(title: "Buy milk", createdAt: .at(1))))

        async let first: Void = engine.sync()
        async let second: Void = engine.sync()
        _ = try await (first, second)

        #expect(await server.pushCount == 1)
        #expect(await server.pullCount == 1)
    }
}
