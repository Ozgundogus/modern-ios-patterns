public protocol UserService: Sendable {
    func fetchUser(id: Int) async throws -> User
}
