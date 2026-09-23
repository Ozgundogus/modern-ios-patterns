import Foundation
import Observation

@MainActor
@Observable
public final class TodoListViewModel {
    public enum SyncStatus: Equatable {
        case idle
        case syncing
        case synced
        case offline
    }

    public private(set) var items: [TodoItem] = []
    public private(set) var pendingChanges = 0
    public private(set) var status: SyncStatus = .idle

    private let store: LocalStore
    private let engine: SyncEngine
    private let now: @Sendable () -> Date

    public init(store: LocalStore, engine: SyncEngine, now: @escaping @Sendable () -> Date = { Date() }) {
        self.store = store
        self.engine = engine
        self.now = now
    }

    // MARK: - User actions

    public func add(_ title: String) async {
        let date = now()
        await store.apply(.upsert(TodoItem(title: title, createdAt: date)))
        await reloadAndSync()
    }

    public func toggle(_ item: TodoItem) async {
        var updated = item
        updated.isDone.toggle()
        updated.updatedAt = now()
        await store.apply(.upsert(updated))
        await reloadAndSync()
    }

    public func delete(_ item: TodoItem) async {
        await store.apply(.delete(id: item.id, at: now()))
        await reloadAndSync()
    }

    // MARK: - Sync

    public func sync() async {
        status = .syncing
        do {
            try await engine.sync()
            status = .synced
        } catch {
            status = .offline
        }
        await reload()
    }

    public func syncWhenOnline(_ monitor: some ConnectivityMonitor) async {
        for await isOnline in monitor.updates() where isOnline {
            await sync()
        }
    }

    public func reload() async {
        items = await store.sortedItems
        pendingChanges = await store.outbox.count
    }

    private func reloadAndSync() async {
        await reload()
        await sync()
    }
}
