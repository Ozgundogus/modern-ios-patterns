import Testing
@testable import OfflineSync

struct StubConnectivityMonitor: ConnectivityMonitor {
    let values: [Bool]

    func updates() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            for value in values { continuation.yield(value) }
            continuation.finish()
        }
    }
}
