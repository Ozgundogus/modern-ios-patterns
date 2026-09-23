import BrewData
import BrewDomain

public struct CatalogInteractor: CatalogInteracting {
    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public func searchCoffees(query: String, roast: Roast?) async throws -> [Coffee] {
        try await dependencies.searchCoffees(query: query, roast: roast)
    }

    public func favoriteIDs() async -> Set<Coffee.ID> {
        await dependencies.favoritesRepository.favoriteIDs()
    }

    public func refreshCatalog() async throws {
        _ = try await dependencies.coffeeRepository.refresh()
    }
}
