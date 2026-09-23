import BrewData

/// Builds every screen. The only place in this module that knows about `BrewDependencies`.
@MainActor
public struct SceneFactory {
    private let adapter: DomainAdapter

    public init(dependencies: BrewDependencies) {
        adapter = DomainAdapter(dependencies: dependencies)
    }

    public func makeCatalogViewModel() -> CatalogViewModel {
        CatalogViewModel(catalog: adapter, favorites: adapter)
    }

    public func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(favorites: adapter)
    }

    public func makeDetailViewModel(coffeeID: String) -> CoffeeDetailViewModel {
        CoffeeDetailViewModel(coffeeID: coffeeID, loader: adapter, favorites: adapter, toggler: adapter)
    }
}
