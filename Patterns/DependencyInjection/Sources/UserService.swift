import Foundation

public struct User: Sendable, Equatable, Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let email: String

    public init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    public static let sample = User(id: 1, name: "Ada Lovelace", email: "ada@example.com")
}

/// The abstraction the view model depends on.
/// `Sendable` lets any implementation be shared safely across concurrency domains.
public protocol UserService: Sendable {
    func fetchUser(id: Int) async throws -> User
}

/// Production implementation backed by `URLSession`.
public struct RemoteUserService: UserService {
    private let session: URLSession
    private let baseURL: URL

    public init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    public func fetchUser(id: Int) async throws -> User {
        let url = baseURL.appending(path: "users/\(id)")
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(User.self, from: data)
    }
}

/// Returns a fixed result. Used by previews and tests, no network needed.
public struct StubUserService: UserService {
    public var result: Result<User, any Error>
    public var delay: Duration

    public init(result: Result<User, any Error>, delay: Duration = .zero) {
        self.result = result
        self.delay = delay
    }

    public func fetchUser(id: Int) async throws -> User {
        try await Task.sleep(for: delay)
        return try result.get()
    }
}

public struct StubError: LocalizedError, Equatable {
    public let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var errorDescription: String? { message }
}
