public struct Article: Sendable, Equatable, Identifiable, Codable {
    public let id: Int
    public let title: String
    public let summary: String

    public init(id: Int, title: String, summary: String) {
        self.id = id
        self.title = title
        self.summary = summary
    }
}

extension Article {
    public static let samples = [
        Article(id: 1, title: "Swift 6 Is Here", summary: "Strict concurrency checking is on by default."),
        Article(id: 2, title: "Meet Observation", summary: "Fine-grained updates with @Observable, no Combine needed."),
        Article(id: 3, title: "Actors In Practice", summary: "Protecting shared state without locks."),
    ]
}
