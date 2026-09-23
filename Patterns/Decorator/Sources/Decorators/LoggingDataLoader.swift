import Foundation

/// Adds logging around any `DataLoader`. The wrapped loader doesn't know it's being logged.
public struct LoggingDataLoader: DataLoader {
    private let base: any DataLoader
    private let log: @Sendable (String) -> Void

    public init(base: any DataLoader, log: @escaping @Sendable (String) -> Void) {
        self.base = base
        self.log = log
    }

    public func data(from url: URL) async throws -> Data {
        log("→ GET \(url.path())")
        let clock = ContinuousClock()
        let start = clock.now
        do {
            let data = try await base.data(from: url)
            let elapsed = start.duration(to: clock.now)
            log("← \(url.path()) \(data.count) bytes in \(elapsed.formatted(.units(allowed: [.milliseconds])))")
            return data
        } catch {
            log("✕ \(url.path()) \(error.localizedDescription)")
            throw error
        }
    }
}
