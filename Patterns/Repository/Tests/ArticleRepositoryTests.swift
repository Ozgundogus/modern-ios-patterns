import Foundation
import os
import Testing
@testable import Repository

actor StubArticlesAPI: ArticlesAPI {
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

final class TestClock: Sendable {
    private let date = OSAllocatedUnfairLock(initialState: Date(timeIntervalSince1970: 0))

    var now: Date { date.withLock { $0 } }

    func advance(by seconds: TimeInterval) {
        date.withLock { $0.addTimeInterval(seconds) }
    }
}

let post = PostDTO(id: 1, userId: 7, title: "hello world", body: "line one\nline two")
let article = Article(id: 1, title: "Hello World", summary: "line one line two")

struct ArticleRepositoryTests {
    let clock = TestClock()
    let cache = InMemoryArticleCache()

    func makeRepository(api: StubArticlesAPI) -> DefaultArticleRepository {
        let clock = clock
        return DefaultArticleRepository(api: api, cache: cache, maxAge: 300, now: { clock.now })
    }

    @Test func mapsDTOsToDomainModels() async throws {
        let repository = makeRepository(api: StubArticlesAPI(result: .success([post])))

        #expect(try await repository.articles() == [article])
    }

    @Test func firstLoadFetchesAndFillsTheCache() async throws {
        let api = StubArticlesAPI(result: .success([post]))

        _ = try await makeRepository(api: api).articles()

        #expect(await api.callCount == 1)
        #expect(await cache.load() == CachedArticles(articles: [article], savedAt: clock.now))
    }

    @Test func freshCacheSkipsTheNetwork() async throws {
        let api = StubArticlesAPI(result: .success([post]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 60)
        _ = try await repository.articles()

        #expect(await api.callCount == 1)
    }

    @Test func staleCacheIsRefreshed() async throws {
        let api = StubArticlesAPI(result: .success([post]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 301)
        _ = try await repository.articles()

        #expect(await api.callCount == 2)
    }

    @Test func networkFailureFallsBackToStaleCache() async throws {
        let api = StubArticlesAPI(result: .success([post]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 301)
        await api.setResult(.failure(URLError(.notConnectedToInternet)))

        #expect(try await repository.articles() == [article])
    }

    @Test func networkFailureWithoutCacheThrows() async {
        let repository = makeRepository(api: StubArticlesAPI(result: .failure(URLError(.notConnectedToInternet))))

        await #expect(throws: URLError.self) {
            try await repository.articles()
        }
    }

    @Test func refreshAlwaysHitsTheNetwork() async throws {
        let api = StubArticlesAPI(result: .success([post]))
        let repository = makeRepository(api: api)

        _ = try await repository.refresh()
        _ = try await repository.refresh()

        #expect(await api.callCount == 2)
    }
}

struct DiskArticleCacheTests {
    @Test func roundTripsThroughAFile() async {
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).json")
        defer { try? FileManager.default.removeItem(at: fileURL) }
        let entry = CachedArticles(articles: Article.samples, savedAt: Date(timeIntervalSince1970: 1_000))

        await DiskArticleCache(fileURL: fileURL).save(entry)

        #expect(await DiskArticleCache(fileURL: fileURL).load() == entry)
    }

    @Test func missingFileLoadsNothing() async {
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).json")

        #expect(await DiskArticleCache(fileURL: fileURL).load() == nil)
    }
}

@MainActor
struct ArticleListViewModelTests {
    @Test func failedRefreshKeepsTheCurrentList() async {
        let api = StubArticlesAPI(result: .success([post]))
        let viewModel = ArticleListViewModel(
            repository: DefaultArticleRepository(api: api, cache: InMemoryArticleCache())
        )
        await viewModel.load()

        await api.setResult(.failure(URLError(.timedOut)))
        await viewModel.refresh()

        #expect(viewModel.state == .loaded([article]))
    }

    @Test func failedFirstLoadShowsAnError() async {
        let viewModel = ArticleListViewModel(repository: DefaultArticleRepository(
            api: StubArticlesAPI(result: .failure(URLError(.notConnectedToInternet))),
            cache: InMemoryArticleCache()
        ))

        await viewModel.load()

        guard case .failed = viewModel.state else {
            Issue.record("Expected a failed state, got \(viewModel.state)")
            return
        }
    }
}
