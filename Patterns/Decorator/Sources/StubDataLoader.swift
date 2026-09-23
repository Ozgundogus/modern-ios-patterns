import Foundation

/// Returns scripted responses in order; the last one repeats. Used by previews and tests.
public actor StubDataLoader: DataLoader {
    private var responses: [Result<Data, any Error>]
    private let latency: Duration
    public private(set) var callCount = 0

    public init(responses: [Result<Data, any Error>], latency: Duration = .zero) {
        precondition(!responses.isEmpty, "StubDataLoader needs at least one response")
        self.responses = responses
        self.latency = latency
    }

    public func data(from url: URL) async throws -> Data {
        callCount += 1
        if latency > .zero {
            try await Task.sleep(for: latency)
        }
        let response = responses.count > 1 ? responses.removeFirst() : responses[0]
        return try response.get()
    }
}
