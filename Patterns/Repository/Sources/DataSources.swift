import Foundation

// MARK: - Remote

public protocol ArticlesAPI: Sendable {
    func fetchPosts() async throws -> [PostDTO]
}

public struct RemoteArticlesAPI: ArticlesAPI {
    private let session: URLSession
    private let url: URL

    public init(
        session: URLSession = .shared,
        url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    ) {
        self.session = session
        self.url = url
    }

    public func fetchPosts() async throws -> [PostDTO] {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([PostDTO].self, from: data)
    }
}

// MARK: - Local

public struct CachedArticles: Sendable, Equatable, Codable {
    public let articles: [Article]
    public let savedAt: Date

    public init(articles: [Article], savedAt: Date) {
        self.articles = articles
        self.savedAt = savedAt
    }
}

public protocol ArticleCache: Sendable {
    func load() async -> CachedArticles?
    func save(_ entry: CachedArticles) async
}

public actor InMemoryArticleCache: ArticleCache {
    private var entry: CachedArticles?

    public init(entry: CachedArticles? = nil) {
        self.entry = entry
    }

    public func load() -> CachedArticles? {
        entry
    }

    public func save(_ entry: CachedArticles) {
        self.entry = entry
    }
}

public actor DiskArticleCache: ArticleCache {
    private let fileURL: URL

    public init(fileURL: URL = URL.cachesDirectory.appending(path: "articles.json")) {
        self.fileURL = fileURL
    }

    public func load() -> CachedArticles? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(CachedArticles.self, from: data)
    }

    public func save(_ entry: CachedArticles) {
        guard let data = try? JSONEncoder().encode(entry) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
