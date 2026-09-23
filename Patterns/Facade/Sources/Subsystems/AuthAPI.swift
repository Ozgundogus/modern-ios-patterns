public protocol AuthAPI: Sendable {
    func signIn(email: String, password: String) async throws -> AuthTokens
    func refresh(refreshToken: String) async throws -> AuthTokens
    func profile(accessToken: String) async throws -> UserProfile
    func signOut(refreshToken: String) async throws
}
