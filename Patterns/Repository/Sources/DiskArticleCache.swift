import Foundation

public actor DiskArticleCache: ArticleCache {
    private let fileURL: URL

    public init(fileURL: URL = URL.cachesDirectory.appending(path: "articles.json")) {
        self.fileURL = fileURL
    }

    public func load() -> CachedArticles? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(CachedArticles.self, from: data)
    }

    public func save(_ entry: CachedArticles) {
        guard let data = try? JSONEncoder().encode(entry) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
