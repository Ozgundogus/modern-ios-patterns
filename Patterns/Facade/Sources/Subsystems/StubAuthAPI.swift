import Foundation

/// A fake backend for previews and tests. Accepts `ada@example.com` / `password`.
public actor StubAuthAPI: AuthAPI {
    public static let validEmail = "ada@example.com"
    public static let validPassword = "password"

    public private(set) var refreshCount = 0
    public private(set) var revokedRefreshTokens: [String] = []

    private var refreshFails = false
    private var issuedTokens = 0
    private let latency: Duration
    private let now: @Sendable () -> Date

    public init(latency: Duration = .zero, now: @escaping @Sendable () -> Date = { Date() }) {
        self.latency = latency
        self.now = now
    }

    public func setRefreshFails(_ fails: Bool) {
        refreshFails = fails
    }

    public func signIn(email: String, password: String) async throws -> AuthTokens {
        try await simulateLatency()
        guard email == Self.validEmail, password == Self.validPassword else {
            throw AuthError.invalidCredentials
        }
        return issueTokens()
    }

    public func refresh(refreshToken: String) async throws -> AuthTokens {
        try await simulateLatency()
        refreshCount += 1
        if refreshFails {
            throw AuthError.sessionExpired
        }
        return issueTokens()
    }

    public func profile(accessToken: String) async throws -> UserProfile {
        try await simulateLatency()
        return .ada
    }

    public func signOut(refreshToken: String) async throws {
        revokedRefreshTokens.append(refreshToken)
    }

    private func issueTokens() -> AuthTokens {
        issuedTokens += 1
        return AuthTokens(
            accessToken: "access-\(issuedTokens)",
            refreshToken: "refresh-\(issuedTokens)",
            expiresAt: now().addingTimeInterval(3_600)
        )
    }

    private func simulateLatency() async throws {
        if latency > .zero {
            try await Task.sleep(for: latency)
        }
    }
}
