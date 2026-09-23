#if canImport(SwiftUI)
import SwiftUI

public struct ArticleListView: View {
    @State private var viewModel: ArticleListViewModel

    public init(viewModel: ArticleListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        content
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let articles):
            List(articles) { article in
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title).font(.headline)
                    Text(article.summary).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                }
            }
            .refreshable { await viewModel.refresh() }
        case .failed(let message):
            ContentUnavailableView(
                "Couldn't load articles",
                systemImage: "wifi.slash",
                description: Text(message)
            )
        }
    }
}

// MARK: - Previews

private struct PreviewArticleAPI: ArticleAPI {
    var fails = false

    func fetchPosts() async throws -> [PostDTO] {
        try await Task.sleep(for: .milliseconds(400))
        if fails { throw URLError(.notConnectedToInternet) }
        return Article.samples.map { PostDTO(id: $0.id, userID: 1, title: $0.title, body: $0.summary) }
    }
}

#Preview("Network") {
    ArticleListView(viewModel: ArticleListViewModel(
        repository: DefaultArticleRepository(api: PreviewArticleAPI(), cache: InMemoryArticleCache())
    ))
}

#Preview("Offline, stale cache") {
    let staleCache = InMemoryArticleCache(entry: CachedArticles(articles: Article.samples, savedAt: .distantPast))
    return ArticleListView(viewModel: ArticleListViewModel(
        repository: DefaultArticleRepository(api: PreviewArticleAPI(fails: true), cache: staleCache)
    ))
}

#Preview("Offline, empty cache") {
    ArticleListView(viewModel: ArticleListViewModel(
        repository: DefaultArticleRepository(api: PreviewArticleAPI(fails: true), cache: InMemoryArticleCache())
    ))
}

#Preview("Live") {
    ArticleListView(viewModel: ArticleListViewModel(repository: DefaultArticleRepository.live()))
}
#endif
