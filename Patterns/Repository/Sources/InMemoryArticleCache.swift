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
