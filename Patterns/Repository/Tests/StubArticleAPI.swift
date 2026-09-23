import Testing
@testable import Repository

actor StubArticleAPI: ArticleAPI {
    private var result: Result<[PostDTO], any Error>
    private(set) var callCount = 0

    init(result: Result<[PostDTO], any Error>) {
        self.result = result
    }

    func setResult(_ result: Result<[PostDTO], any Error>) {
        self.result = result
    }

    func fetchPosts() async throws -> [PostDTO] {
        callCount += 1
        return try result.get()
    }
}
