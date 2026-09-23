import Foundation
import Observation

public protocol AppLogger: Sendable {
    func log(_ message: String)
}

public struct ConsoleLogger: AppLogger {
    public init() {}

    public func log(_ message: String) {
        print("[app] \(message)")
    }
}

public protocol HTTPClient: Sendable {
    func get(_ url: URL) async throws -> Data
}

/// Depends on `AppLogger`, so the container has to build the logger first.
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

/// State that belongs to one checkout flow. Each flow needs a fresh cart.
public actor CartStore {
    public private(set) var items: [String] = []

    public init() {}

    public func add(_ item: String) {
        items.append(item)
    }
}

/// Knows nothing about the container. It receives exactly what it uses.
@MainActor
@Observable
public final class CheckoutViewModel {
    public private(set) var items: [String] = []

    private let cart: CartStore
    private let logger: any AppLogger

    public init(cart: CartStore, logger: any AppLogger) {
        self.cart = cart
        self.logger = logger
    }

    public func add(_ item: String) async {
        await cart.add(item)
        items = await cart.items
        logger.log("Added \(item) to cart")
    }
}
