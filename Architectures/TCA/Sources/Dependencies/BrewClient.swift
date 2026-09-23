import BrewData
import BrewDomain
import ComposableArchitecture

/// The feature's view of the outside world. Tests replace any endpoint with a closure.
@DependencyClient
public struct BrewClient: Sendable {
    public var searchCoffees: @Sendable (_ query: String, _ roast: Roast?) async throws -> [Coffee]
    public var refreshCatalog: @Sendable () async throws -> Void
    public var favoriteIDs: @Sendable () async -> Set<Coffee.ID> = { [] }
    public var favoriteCoffees: @Sendable () async throws -> [Coffee]
    public var toggleFavorite: @Sendable (_ id: Coffee.ID) async -> Bool = { _ in false }
}

extension BrewClient {
    public static func from(_ dependencies: BrewDependencies) -> BrewClient {
        BrewClient(
            searchCoffees: { query, roast in try await dependencies.searchCoffees(query: query, roast: roast) },
            refreshCatalog: { _ = try await dependencies.coffeeRepository.refresh() },
            favoriteIDs: { await dependencies.favoritesRepository.favoriteIDs() },
            favoriteCoffees: { try await dependencies.loadFavoriteCoffees() },
            toggleFavorite: { id in await dependencies.toggleFavorite(id) }
        )
    }
}

extension BrewClient: DependencyKey {
    public static let liveValue = BrewClient.from(.live())
    public static let previewValue = BrewClient.from(.preview())
    public static let testValue = BrewClient()
}

extension DependencyValues {
    public var brew: BrewClient {
        get { self[BrewClient.self] }
        set { self[BrewClient.self] = newValue }
    }
}
