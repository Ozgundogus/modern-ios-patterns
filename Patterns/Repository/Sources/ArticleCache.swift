public protocol ArticleCache: Sendable {
    func load() async -> CachedArticles?
    func save(_ entry: CachedArticles) async
}
