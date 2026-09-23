import BrewDomain

/// Presenter → Interactor. Business work, no UI.
public protocol CatalogInteracting: Sendable {
    func searchCoffees(query: String, roast: Roast?) async throws -> [Coffee]
    func favoriteIDs() async -> Set<Coffee.ID>
    func refreshCatalog() async throws
}
