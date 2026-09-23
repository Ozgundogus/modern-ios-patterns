import Foundation
import Testing
@testable import Decorator

struct CachingDataLoaderTests {
    @Test func servesRepeatedRequestsFromMemory() async throws {
        let stub = StubDataLoader(responses: [.success(.image)])
        let loader = stub.caching()

        _ = try await loader.data(from: .avatar)
        let second = try await loader.data(from: .avatar)

        #expect(second == .image)
        #expect(await stub.callCount == 1)
    }

    @Test func cachesEachURLSeparately() async throws {
        let stub = StubDataLoader(responses: [.success(.image)])
        let loader = stub.caching()

        _ = try await loader.data(from: .avatar)
        _ = try await loader.data(from: .banner)

        #expect(await stub.callCount == 2)
    }

    @Test func mergesConcurrentRequestsForTheSameURL() async throws {
        let stub = StubDataLoader(responses: [.success(.image)], latency: .milliseconds(100))
        let loader = stub.caching()

        async let first = loader.data(from: .avatar)
        async let second = loader.data(from: .avatar)
        _ = try await (first, second)

        #expect(await stub.callCount == 1)
    }

    @Test func failuresAreNotCached() async throws {
        let stub = StubDataLoader(responses: [.failure(URLError(.timedOut)), .success(.image)])
        let loader = stub.caching()

        _ = try? await loader.data(from: .avatar)
        let data = try await loader.data(from: .avatar)

        #expect(data == .image)
        #expect(await stub.callCount == 2)
    }
}
