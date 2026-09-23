import Foundation
import Network

public protocol ConnectivityMonitor: Sendable {
    /// Emits `true` when the device is online, `false` when it goes offline.
    func updates() -> AsyncStream<Bool>
}

/// Wraps `NWPathMonitor` in an `AsyncStream`, so callers can write `for await isOnline in …`.
public struct NetworkConnectivityMonitor: ConnectivityMonitor {
    public init() {}

    public func updates() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            continuation.onTermination = { _ in
                monitor.cancel()
            }
            monitor.start(queue: DispatchQueue(label: "ConnectivityMonitor"))
        }
    }
}
