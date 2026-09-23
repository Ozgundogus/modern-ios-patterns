import Foundation
import Testing
@testable import Repository

struct DefaultArticleRepositoryTests {
    let clock = TestClock()
    let cache = InMemoryArticleCache()

    func makeRepository(api: StubArticleAPI) -> DefaultArticleRepository {
        let clock = clock
        return DefaultArticleRepository(api: api, cache: cache, maxAge: 300, now: { clock.now })
    }

    @Test func mapsDTOsToDomainModels() async throws {
        let repository = makeRepository(api: StubArticleAPI(result: .success([.fixture])))

        #expect(try await repository.articles() == [.fixture])
    }

    @Test func firstLoadFetchesAndFillsTheCache() async throws {
        let api = StubArticleAPI(result: .success([.fixture]))

        _ = try await makeRepository(api: api).articles()

        #expect(await api.callCount == 1)
        #expect(await cache.load() == CachedArticles(articles: [.fixture], savedAt: clock.now))
    }

    @Test func freshCacheSkipsTheNetwork() async throws {
        let api = StubArticleAPI(result: .success([.fixture]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 60)
        _ = try await repository.articles()

        #expect(await api.callCount == 1)
    }

    @Test func staleCacheIsRefreshed() async throws {
        let api = StubArticleAPI(result: .success([.fixture]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 301)
        _ = try await repository.articles()

        #expect(await api.callCount == 2)
    }

    @Test func networkFailureFallsBackToStaleCache() async throws {
        let api = StubArticleAPI(result: .success([.fixture]))
        let repository = makeRepository(api: api)
        _ = try await repository.articles()

        clock.advance(by: 301)
        await api.setResult(.failure(URLError(.notConnectedToInternet)))

        #expect(try await repository.articles() == [.fixture])
    }

    @Test func networkFailureWithoutCacheThrows() async {
        let repository = makeRepository(api: StubArticleAPI(result: .failure(URLError(.notConnectedToInternet))))

        await #expect(throws: URLError.self) {
            try await repository.articles()
        }
    }

    @Test func refreshAlwaysHitsTheNetwork() async throws {
        let api = StubArticleAPI(result: .success([.fixture]))
        let repository = makeRepository(api: api)

        _ = try await repository.refresh()
        _ = try await repository.refresh()

        #expect(await api.callCount == 2)
    }
}
