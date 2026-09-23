import Foundation

public protocol DataLoader: Sendable {
    func data(from url: URL) async throws -> Data
}
