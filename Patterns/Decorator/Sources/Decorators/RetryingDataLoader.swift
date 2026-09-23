import Foundation

public struct RetryingDataLoader: DataLoader {
    private let base: any DataLoader
    private let attempts: Int
    private let delay: Duration

    public init(base: any DataLoader, attempts: Int, delay: Duration) {
        self.base = base
        self.attempts = attempts
        self.delay = delay
    }

    /// Cancellation is never retried: a cancelled screen shouldn't keep the network busy.
    public func data(from url: URL) async throws -> Data {
        var attempt = 1
        while true {
            do {
                return try await base.data(from: url)
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                guard attempt < attempts else { throw error }
                try await Task.sleep(for: delay)
                attempt += 1
            }
        }
    }
}
