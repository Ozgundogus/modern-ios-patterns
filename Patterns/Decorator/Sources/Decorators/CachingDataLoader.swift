import Foundation

/// Serves repeated requests from memory and merges concurrent requests for the same URL into one.
public actor CachingDataLoader: DataLoader {
    private let base: any DataLoader
    private var cache: [URL: Data] = [:]
    private var inFlight: [URL: Task<Data, any Error>] = [:]

    public init(base: any DataLoader) {
        self.base = base
    }

    public func data(from url: URL) async throws -> Data {
        if let cached = cache[url] {
            return cached
        }
        if let running = inFlight[url] {
            return try await running.value
        }

        let task = Task { try await base.data(from: url) }
        inFlight[url] = task
        defer { inFlight[url] = nil }

        let data = try await task.value
        cache[url] = data
        return data
    }

    public func removeAll() {
        cache.removeAll()
    }
}
