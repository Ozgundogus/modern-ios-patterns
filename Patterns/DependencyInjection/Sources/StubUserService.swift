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
