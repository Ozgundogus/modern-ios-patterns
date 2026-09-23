import BrewData
import BrewDomain

/// The adapter layer: implements the application's ports with the domain use cases and repositories.
/// Presentation code depends on the ports only, never on `BrewDependencies`.
public struct DomainAdapter: CoffeeSearching, CoffeeLoading, FavoritesReading, FavoriteToggling {
    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public func search(query: String, roast: Roast?) async throws -> [Coffee] {
        try await dependencies.searchCoffees(query: query, roast: roast)
    }

    public func refreshCatalog() async throws {
        _ = try await dependencies.coffeeRepository.refresh()
    }

    public func coffee(id: Coffee.ID) async throws -> Coffee {
        try await dependencies.coffeeRepository.coffee(id: id)
    }

    public func favoriteIDs() async -> Set<Coffee.ID> {
        await dependencies.favoritesRepository.favoriteIDs()
    }

    public func favoriteCoffees() async throws -> [Coffee] {
        try await dependencies.loadFavoriteCoffees()
    }

    public func toggleFavorite(_ id: Coffee.ID) async -> Bool {
        await dependencies.toggleFavorite(id)
    }
}
