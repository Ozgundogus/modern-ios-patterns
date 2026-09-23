import Foundation

/// The local database and the source of truth for the UI.
/// Every user edit lands here first and is queued in the outbox for the next sync.
public actor LocalStore {
    public private(set) var items: [UUID: TodoItem] = [:]
    public private(set) var outbox: [Change] = []

    public init() {}

    public var sortedItems: [TodoItem] {
        items.values.sorted { $0.createdAt < $1.createdAt }
    }

    /// Applies a user edit immediately and queues it. No network involved.
    public func apply(_ change: Change) {
        switch change {
        case .upsert(let item):
            items[item.id] = item
        case .delete(let id, _):
            items[id] = nil
        }
        outbox.append(change)
    }

    /// Removes changes the server has accepted. Only the sync engine calls this,
    /// and new edits are only ever appended, so the pushed changes are always at the front.
    func removePushed(count: Int) {
        outbox.removeFirst(count)
    }

    /// Takes the server's state, except for items with changes still waiting in the outbox.
    /// Those were edited during the sync and will be pushed next time.
    func merge(serverItems: [TodoItem]) {
        let pendingIDs = Set(outbox.map(\.itemID))
        var merged = Dictionary(uniqueKeysWithValues: serverItems.map { ($0.id, $0) })
        for id in pendingIDs {
            merged[id] = items[id]
        }
        items = merged
    }
}
