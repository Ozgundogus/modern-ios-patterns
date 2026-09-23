public actor InMemoryTokenStore: TokenStore {
    private var tokens: AuthTokens?

    public init(tokens: AuthTokens? = nil) {
        self.tokens = tokens
    }

    public func load() -> AuthTokens? {
        tokens
    }

    public func save(_ tokens: AuthTokens) {
        self.tokens = tokens
    }

    public func clear() {
        tokens = nil
    }
}
