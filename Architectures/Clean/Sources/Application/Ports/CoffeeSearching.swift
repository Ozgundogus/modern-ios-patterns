import BrewDomain

public protocol CoffeeSearching: Sendable {
    func search(query: String, roast: Roast?) async throws -> [Coffee]
    func refreshCatalog() async throws
}
