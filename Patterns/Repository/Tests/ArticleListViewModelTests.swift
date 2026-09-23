import Foundation
import Testing
@testable import Repository

@MainActor
struct ArticleListViewModelTests {
    @Test func failedRefreshKeepsTheCurrentList() async {
        let api = StubArticleAPI(result: .success([.fixture]))
        let viewModel = ArticleListViewModel(
            repository: DefaultArticleRepository(api: api, cache: InMemoryArticleCache())
        )
        await viewModel.load()

        await api.setResult(.failure(URLError(.timedOut)))
        await viewModel.refresh()

        #expect(viewModel.state == .loaded([.fixture]))
    }

    @Test func failedFirstLoadShowsAnError() async {
        let viewModel = ArticleListViewModel(repository: DefaultArticleRepository(
            api: StubArticleAPI(result: .failure(URLError(.notConnectedToInternet))),
            cache: InMemoryArticleCache()
        ))

        await viewModel.load()

        guard case .failed = viewModel.state else {
            Issue.record("Expected a failed state, got \(viewModel.state)")
            return
        }
    }
}
