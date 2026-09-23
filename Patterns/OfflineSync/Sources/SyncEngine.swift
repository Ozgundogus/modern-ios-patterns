/// Pushes the outbox, then pulls the server state and merges it.
///
/// It's an actor, but actors are **reentrant**: while one `sync()` is suspended on the network,
/// another call can start. Two overlapping syncs would push the same changes twice.
/// `inFlight` makes concurrent callers share the running sync instead.
public actor SyncEngine {
    private let store: LocalStore
    private let server: any TodoServer
    private var inFlight: Task<Void, any Error>?

    public init(store: LocalStore, server: any TodoServer) {
        self.store = store
        self.server = server
    }

    public func sync() async throws {
        if let inFlight {
            return try await inFlight.value
        }

        let task = Task { try await performSync() }
        inFlight = task
        defer { inFlight = nil }
        try await task.value
    }

    /// Retries with exponential backoff: `baseDelay`, then 2×, 4×…
    public func syncWithRetry(attempts: Int = 3, baseDelay: Duration = .seconds(1)) async throws {
        var attempt = 1
        while true {
            do {
                return try await sync()
            } catch {
                guard attempt < attempts else { throw error }
                try await Task.sleep(for: baseDelay * (1 << (attempt - 1)))
                attempt += 1
            }
        }
    }

    private func performSync() async throws {
        let pending = await store.outbox
        if !pending.isEmpty {
            try await server.push(pending)
            await store.removePushed(count: pending.count)
        }
        let serverItems = try await server.pull()
        await store.merge(serverItems: serverItems)
    }
}
