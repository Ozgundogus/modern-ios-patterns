import Foundation

public struct DefaultArticleRepository: ArticleRepository {
    private let api: any ArticleAPI
    private let cache: any ArticleCache
    private let maxAge: TimeInterval
    private let now: @Sendable () -> Date

    public init(
        api: any ArticleAPI,
        cache: any ArticleCache,
        maxAge: TimeInterval = 5 * 60,
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.api = api
        self.cache = cache
        self.maxAge = maxAge
        self.now = now
    }

    public func articles() async throws -> [Article] {
        let cached = await cache.load()
        if let cached, now().timeIntervalSince(cached.savedAt) < maxAge {
            return cached.articles
        }

        do {
            return try await refresh()
        } catch {
            if let cached {
                return cached.articles
            }
            throw error
        }
    }

    public func refresh() async throws -> [Article] {
        let articles = try await api.fetchPosts().map(Article.init(dto:))
        await cache.save(CachedArticles(articles: articles, savedAt: now()))
        return articles
    }
}

extension DefaultArticleRepository {
    public static func live() -> DefaultArticleRepository {
        DefaultArticleRepository(api: RemoteArticleAPI(), cache: DiskArticleCache())
    }
}
