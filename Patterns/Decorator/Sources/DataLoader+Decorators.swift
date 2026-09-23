import Foundation

/// Fluent composition. Order matters and reads top to bottom, from the network outwards:
/// `URLSessionDataLoader().retrying(attempts: 3).caching().logging { print($0) }`
extension DataLoader {
    public func logging(_ log: @escaping @Sendable (String) -> Void) -> LoggingDataLoader {
        LoggingDataLoader(base: self, log: log)
    }

    public func retrying(attempts: Int, delay: Duration = .milliseconds(300)) -> RetryingDataLoader {
        RetryingDataLoader(base: self, attempts: attempts, delay: delay)
    }

    public func caching() -> CachingDataLoader {
        CachingDataLoader(base: self)
    }
}
