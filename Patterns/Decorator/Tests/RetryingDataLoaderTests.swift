import Foundation
import Testing
@testable import Decorator

struct RetryingDataLoaderTests {
    @Test func succeedsAfterTransientFailures() async throws {
        let stub = StubDataLoader(responses: [.failure(URLError(.timedOut)), .failure(URLError(.timedOut)), .success(.image)])

        let data = try await stub.retrying(attempts: 3, delay: .zero).data(from: .avatar)

        #expect(data == .image)
        #expect(await stub.callCount == 3)
    }

    @Test func givesUpAfterTheLastAttempt() async {
        let stub = StubDataLoader(responses: [.failure(URLError(.timedOut))])

        await #expect(throws: URLError.self) {
            try await stub.retrying(attempts: 3, delay: .zero).data(from: .avatar)
        }
        #expect(await stub.callCount == 3)
    }

    @Test func doesNotRetryCancellation() async {
        let stub = StubDataLoader(responses: [.failure(CancellationError())])

        await #expect(throws: CancellationError.self) {
            try await stub.retrying(attempts: 3, delay: .zero).data(from: .avatar)
        }
        #expect(await stub.callCount == 1)
    }
}
