public protocol ArticleAPI: Sendable {
    func fetchPosts() async throws -> [PostDTO]
}
