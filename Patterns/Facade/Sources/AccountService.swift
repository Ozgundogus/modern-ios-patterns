import Foundation
import Observation

/// The facade. Screens call `signIn`, `restoreSession` and `signOut`;
/// the API calls, token storage, refresh rules and profile loading stay behind it.
@MainActor
@Observable
public final class AccountService {
    public enum State: Equatable {
        case signedOut
        case loading
        case signedIn(UserProfile)
    }

    public private(set) var state: State = .signedOut
    public private(set) var errorMessage: String?

    private let api: any AuthAPI
    private let tokenStore: any TokenStore
    private let now: @Sendable () -> Date

    public init(api: any AuthAPI, tokenStore: any TokenStore, now: @escaping @Sendable () -> Date = { Date() }) {
        self.api = api
        self.tokenStore = tokenStore
        self.now = now
    }

    public func signIn(email: String, password: String) async {
        state = .loading
        errorMessage = nil
        do {
            let tokens = try await api.signIn(email: email, password: password)
            try await tokenStore.save(tokens)
            state = .signedIn(try await api.profile(accessToken: tokens.accessToken))
        } catch {
            try? await tokenStore.clear()
            state = .signedOut
            errorMessage = error.localizedDescription
        }
    }

    /// Call on launch. Refreshes expired tokens and signs out if the refresh fails.
    public func restoreSession() async {
        guard let stored = try? await tokenStore.load() else {
            state = .signedOut
            return
        }
        state = .loading
        do {
            let tokens = try await validTokens(from: stored)
            state = .signedIn(try await api.profile(accessToken: tokens.accessToken))
        } catch {
            try? await tokenStore.clear()
            state = .signedOut
        }
    }

    public func signOut() async {
        if let tokens = try? await tokenStore.load() {
            try? await api.signOut(refreshToken: tokens.refreshToken)
        }
        try? await tokenStore.clear()
        state = .signedOut
    }

    private func validTokens(from tokens: AuthTokens) async throws -> AuthTokens {
        guard tokens.isExpired(at: now()) else { return tokens }
        let refreshed = try await api.refresh(refreshToken: tokens.refreshToken)
        try await tokenStore.save(refreshed)
        return refreshed
    }
}
