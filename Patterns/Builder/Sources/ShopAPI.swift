import Foundation

/// Every endpoint starts from the same configured base builder.
public struct ShopAPI: Sendable {
    private let base: RequestBuilder

    public init(baseURL: URL, token: String) {
        base = RequestBuilder(baseURL: baseURL)
            .header("Accept", "application/json")
            .bearerToken(token)
    }

    public func products(search: String? = nil, category: String? = nil) throws(RequestBuilderError) -> URLRequest {
        try base
            .path("products")
            .query("search", search)
            .query("category", category)
            .build()
    }

    public func placeOrder(_ order: NewOrder) throws(RequestBuilderError) -> URLRequest {
        try base
            .method(.post)
            .path("orders")
            .jsonBody(order)
            .timeout(60)
            .build()
    }

    public func cancelOrder(id: String) throws(RequestBuilderError) -> URLRequest {
        try base
            .method(.delete)
            .path("orders/\(id)")
            .build()
    }
}
