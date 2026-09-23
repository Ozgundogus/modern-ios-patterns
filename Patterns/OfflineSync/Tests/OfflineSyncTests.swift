import Foundation
import Testing
@testable import OfflineSync

func date(_ seconds: TimeInterval) -> Date {
    Date(timeIntervalSince1970: seconds)
}

struct StubConnectivity: ConnectivityMonitor {
    let values: [Bool]

    func updates() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            for value in values { continuation.yield(value) }
            continuation.finish()
        }
    }
}

struct SyncEngineTests {
    let store: LocalStore
    let server: InMemoryServer
    let engine: SyncEngine

    init() {
        store = LocalStore()
        server = InMemoryServer()
        engine = SyncEngine(store: store, server: server)
    }

    @Test func localEditsWorkOffline() async {
        await server.setReachable(false)
        let item = TodoItem(title: "Buy milk", createdAt: date(1))

        await store.apply(.upsert(item))
        await #expect(throws: URLError.self) { try await engine.sync() }

        #expect(await store.sortedItems == [item])
        #expect(await store.outbox == [.upsert(item)])
    }

    @Test func syncPushesTheOutboxAndEmptiesIt() async throws {
        let item = TodoItem(title: "Buy milk", createdAt: date(1))
        await store.apply(.upsert(item))

        try await engine.sync()

        #expect(await store.outbox.isEmpty)
        #expect(await server.items[item.id] == item)
    }

    @Test func offlineChangesArePushedWhenBackOnline() async throws {
        await server.setReachable(false)
        let item = TodoItem(title: "Buy milk", createdAt: date(1))
        await store.apply(.upsert(item))
        try? await engine.sync()

        await server.setReachable(true)
        try await engine.sync()

        #expect(await store.outbox.isEmpty)
        #expect(await server.items[item.id] == item)
    }

    @Test func changesFromAnotherDeviceArePulled() async throws {
        let remote = TodoItem(title: "Added on iPad", createdAt: date(1))
        await server.editFromAnotherDevice(remote)

        try await engine.sync()

        #expect(await store.sortedItems == [remote])
    }

    @Test func newerLocalEditWinsAConflict() async throws {
        let original = TodoItem(title: "Draft", createdAt: date(1))
        await server.editFromAnotherDevice(original)
        try await engine.sync()

        var fromIPad = original
        fromIPad.title = "Edited on iPad"
        fromIPad.updatedAt = date(5)
        await server.editFromAnotherDevice(fromIPad)

        var local = original
        local.title = "Edited on iPhone"
        local.updatedAt = date(10)
        await store.apply(.upsert(local))
        try await engine.sync()

        #expect(await store.items[original.id]?.title == "Edited on iPhone")
        #expect(await server.items[original.id]?.title == "Edited on iPhone")
    }

    @Test func newerRemoteEditWinsAConflict() async throws {
        let original = TodoItem(title: "Draft", createdAt: date(1))
        await server.editFromAnotherDevice(original)
        try await engine.sync()

        var local = original
        local.title = "Edited on iPhone"
        local.updatedAt = date(5)
        await store.apply(.upsert(local))

        var fromIPad = original
        fromIPad.title = "Edited on iPad"
        fromIPad.updatedAt = date(10)
        await server.editFromAnotherDevice(fromIPad)
        try await engine.sync()

        #expect(await store.items[original.id]?.title == "Edited on iPad")
    }

    @Test func deletesAreSynced() async throws {
        let item = TodoItem(title: "Buy milk", createdAt: date(1))
        await store.apply(.upsert(item))
        try await engine.sync()

        await store.apply(.delete(id: item.id, at: date(2)))
        try await engine.sync()

        #expect(await store.items.isEmpty)
        #expect(await server.items.isEmpty)
    }

    @Test func retrySucceedsAfterTransientFailures() async throws {
        await store.apply(.upsert(TodoItem(title: "Buy milk", createdAt: date(1))))
        await server.failNext(2)

        try await engine.syncWithRetry(attempts: 3, baseDelay: .zero)

        #expect(await store.outbox.isEmpty)
    }

    @Test func retryGivesUpAfterTheLastAttempt() async {
        await store.apply(.upsert(TodoItem(title: "Buy milk", createdAt: date(1))))
        await server.failNext(3)

        await #expect(throws: URLError.self) {
            try await engine.syncWithRetry(attempts: 3, baseDelay: .zero)
        }
        #expect(await store.outbox.count == 1)
    }
}

struct ReentrancyTests {
    @Test func concurrentSyncCallsShareOneRequest() async throws {
        let store = LocalStore()
        let server = InMemoryServer(latency: .milliseconds(100))
        let engine = SyncEngine(store: store, server: server)
        await store.apply(.upsert(TodoItem(title: "Buy milk", createdAt: date(1))))

        async let first: Void = engine.sync()
        async let second: Void = engine.sync()
        _ = try await (first, second)

        #expect(await server.pushCount == 1)
        #expect(await server.pullCount == 1)
    }
}

@MainActor
struct TodoListViewModelTests {
    @Test func addShowsTheItemEvenWhenOffline() async {
        let store = LocalStore()
        let server = InMemoryServer()
        await server.setReachable(false)
        let viewModel = TodoListViewModel(store: store, engine: SyncEngine(store: store, server: server))

        await viewModel.add("Buy milk")

        #expect(viewModel.items.map(\.title) == ["Buy milk"])
        #expect(viewModel.pendingChanges == 1)
        #expect(viewModel.status == .offline)
    }

    @Test func comingBackOnlineSyncsPendingChanges() async {
        let store = LocalStore()
        let server = InMemoryServer()
        await server.setReachable(false)
        let viewModel = TodoListViewModel(store: store, engine: SyncEngine(store: store, server: server))
        await viewModel.add("Buy milk")

        await server.setReachable(true)
        await viewModel.syncWhenOnline(StubConnectivity(values: [false, true]))

        #expect(viewModel.pendingChanges == 0)
        #expect(viewModel.status == .synced)
        #expect(await server.items.count == 1)
    }
}
