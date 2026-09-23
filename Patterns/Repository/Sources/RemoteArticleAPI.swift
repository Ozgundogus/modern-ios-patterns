import Foundation

public struct RemoteArticleAPI: ArticleAPI {
    private let session: URLSession
    private let url: URL

    public init(
        session: URLSession = .shared,
        url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    ) {
        self.session = session
        self.url = url
    }

    public func fetchPosts() async throws -> [PostDTO] {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([PostDTO].self, from: data)
    }
}
