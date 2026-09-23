import Foundation

public struct CachedArticles: Sendable, Equatable, Codable {
    public let articles: [Article]
    public let savedAt: Date

    public init(articles: [Article], savedAt: Date) {
        self.articles = articles
        self.savedAt = savedAt
    }
}
