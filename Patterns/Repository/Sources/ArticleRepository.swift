public protocol ArticleRepository: Sendable {
    /// Returns fresh cached articles when possible, otherwise fetches them.
    /// Falls back to stale cached data when the network fails.
    func articles() async throws -> [Article]

    /// Always fetches from the network and updates the cache.
    func refresh() async throws -> [Article]
}
