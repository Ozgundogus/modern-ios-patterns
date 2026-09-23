public protocol TodoServer: Sendable {
    /// Sends local changes. The server resolves conflicts (last write wins).
    func push(_ changes: [Change]) async throws
    func pull() async throws -> [TodoItem]
}
