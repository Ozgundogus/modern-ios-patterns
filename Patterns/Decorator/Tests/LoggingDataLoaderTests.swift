import Foundation
import Testing
@testable import Decorator

struct LoggingDataLoaderTests {
    @Test func logsTheRequestAndTheResponse() async throws {
        let log = SpyLogSink()
        let loader = StubDataLoader(responses: [.success(.image)]).logging { log.append($0) }

        _ = try await loader.data(from: .avatar)

        #expect(log.lines.count == 2)
        #expect(log.lines.first == "→ GET /avatar.png")
        #expect(log.lines.last?.hasPrefix("← /avatar.png 4 bytes in") == true)
    }

    @Test func logsAndRethrowsFailures() async {
        let log = SpyLogSink()
        let loader = StubDataLoader(responses: [.failure(URLError(.timedOut))]).logging { log.append($0) }

        await #expect(throws: URLError.self) {
            try await loader.data(from: .avatar)
        }
        #expect(log.lines.last?.hasPrefix("✕ /avatar.png") == true)
    }
}
