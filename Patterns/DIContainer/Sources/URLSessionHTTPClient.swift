import Foundation

public struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let logger: any AppLogger

    public init(session: URLSession = .shared, logger: any AppLogger) {
        self.session = session
        self.logger = logger
    }

    public func get(_ url: URL) async throws -> Data {
        logger.log("GET \(url.absoluteString)")
        return try await session.data(from: url).0
    }
}
