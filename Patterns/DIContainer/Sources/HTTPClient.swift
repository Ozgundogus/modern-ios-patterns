import Foundation

public protocol HTTPClient: Sendable {
    func get(_ url: URL) async throws -> Data
}
