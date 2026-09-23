import Foundation
import Testing
@testable import Decorator

struct DecoratorCompositionTests {
    @Test func stackedDecoratorsWorkTogether() async throws {
        let stub = StubDataLoader(responses: [.failure(URLError(.timedOut)), .success(.image)])
        let log = SpyLogSink()
        let loader = stub
            .retrying(attempts: 3, delay: .zero)
            .caching()
            .logging { log.append($0) }

        let first = try await loader.data(from: .avatar)
        let second = try await loader.data(from: .avatar)

        #expect(first == .image)
        #expect(second == .image)
        #expect(await stub.callCount == 2)
        #expect(log.lines.filter { $0.hasPrefix("→") }.count == 2)
    }
}
