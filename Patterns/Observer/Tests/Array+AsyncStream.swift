extension Array where Element: Sendable {
    /// Collects a finished stream into an array.
    init(_ stream: AsyncStream<Element>) async {
        var elements: [Element] = []
        for await element in stream {
            elements.append(element)
        }
        self = elements
    }
}
