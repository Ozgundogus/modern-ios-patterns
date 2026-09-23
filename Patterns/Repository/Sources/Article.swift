import Foundation

/// The domain model: what the app cares about, shaped for the UI.
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

/// The API's shape. It stays inside the data layer and never reaches a view model.
public struct PostDTO: Sendable, Equatable, Decodable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String

    public init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

extension Article {
    init(dto: PostDTO) {
        self.init(
            id: dto.id,
            title: dto.title.capitalized,
            summary: dto.body.replacingOccurrences(of: "\n", with: " ")
        )
    }
}

extension Article {
    public static let samples = [
        Article(id: 1, title: "Swift 6 Is Here", summary: "Strict concurrency checking is on by default."),
        Article(id: 2, title: "Meet Observation", summary: "Fine-grained updates with @Observable, no Combine needed."),
        Article(id: 3, title: "Actors In Practice", summary: "Protecting shared state without locks."),
    ]
}
