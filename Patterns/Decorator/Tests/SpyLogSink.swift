import os

final class SpyLogSink: Sendable {
    private let storage = OSAllocatedUnfairLock<[String]>(initialState: [])

    var lines: [String] { storage.withLock { $0 } }

    func append(_ line: String) {
        storage.withLock { $0.append(line) }
    }
}
