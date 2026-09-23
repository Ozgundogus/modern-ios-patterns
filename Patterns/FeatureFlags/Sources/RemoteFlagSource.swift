public protocol RemoteFlagSource: Sendable {
    func fetchFlags() async throws -> [String: FlagValue]
}
