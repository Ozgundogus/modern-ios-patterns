public actor StubFlagSource: RemoteFlagSource {
    private var result: Result<[String: FlagValue], any Error>

    public init(_ values: [String: FlagValue] = [:]) {
        result = .success(values)
    }

    public func setValues(_ values: [String: FlagValue]) {
        result = .success(values)
    }

    public func setError(_ error: any Error) {
        result = .failure(error)
    }

    public func fetchFlags() async throws -> [String: FlagValue] {
        try result.get()
    }
}
