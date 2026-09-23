import Foundation

/// `AsyncStream` supports only one consumer. `Broadcaster` gives every subscriber its own stream
/// and forgets it as soon as the subscriber stops listening.
public actor Broadcaster<Element: Sendable> {
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]

    public init() {}

    public var subscriberCount: Int {
        continuations.count
    }

    public func subscribe() -> AsyncStream<Element> {
        let (stream, continuation) = AsyncStream.makeStream(of: Element.self)
        let id = UUID()
        continuations[id] = continuation
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeSubscriber(id) }
        }
        return stream
    }

    public func send(_ element: Element) {
        for continuation in continuations.values {
            continuation.yield(element)
        }
    }

    public func finish() {
        for continuation in continuations.values {
            continuation.finish()
        }
        continuations.removeAll()
    }

    private func removeSubscriber(_ id: UUID) {
        continuations[id] = nil
    }
}
