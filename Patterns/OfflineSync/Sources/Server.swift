import Foundation

public protocol TodoServer: Sendable {
    /// Sends local changes. The server resolves conflicts (last write wins).
    func push(_ changes: [Change]) async throws
    func pull() async throws -> [TodoItem]
}

/// A fake backend for previews and tests: it can go offline, fail requests and receive edits from another device.
public actor InMemoryServer: TodoServer {
    public private(set) var items: [UUID: TodoItem] = [:]
    public private(set) var pushCount = 0
    public private(set) var pullCount = 0

    private var tombstones: [UUID: Date] = [:]
    private var isReachable = true
    private var failuresRemaining = 0
    private let latency: Duration

    public init(latency: Duration = .zero) {
        self.latency = latency
    }

    public func setReachable(_ reachable: Bool) {
        isReachable = reachable
    }

    /// The next `count` requests fail with a timeout.
    public func failNext(_ count: Int) {
        failuresRemaining = count
    }

    public func editFromAnotherDevice(_ item: TodoItem) {
        apply(.upsert(item))
    }

    public func push(_ changes: [Change]) async throws {
        try await simulateRequest()
        pushCount += 1
        for change in changes {
            apply(change)
        }
    }

    public func pull() async throws -> [TodoItem] {
        try await simulateRequest()
        pullCount += 1
        return Array(items.values)
    }

    private func simulateRequest() async throws {
        if latency > .zero {
            try await Task.sleep(for: latency)
        }
        guard isReachable else { throw URLError(.notConnectedToInternet) }
        if failuresRemaining > 0 {
            failuresRemaining -= 1
            throw URLError(.timedOut)
        }
    }

    /// Last write wins: an older change never overwrites a newer one.
    private func apply(_ change: Change) {
        switch change {
        case .upsert(let item):
            if let deletedAt = tombstones[item.id], deletedAt >= item.updatedAt { return }
            if let existing = items[item.id], existing.updatedAt > item.updatedAt { return }
            items[item.id] = item
            tombstones[item.id] = nil
        case .delete(let id, let deletedAt):
            if let existing = items[id], existing.updatedAt > deletedAt { return }
            items[id] = nil
            tombstones[id] = deletedAt
        }
    }
}
