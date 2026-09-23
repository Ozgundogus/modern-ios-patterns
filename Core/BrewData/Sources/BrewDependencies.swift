import BrewDomain
import Foundation

/// The Composition Root for every Brew app. Presentation layers only see the domain protocols.
public struct BrewDependencies: Sendable {
    public let coffeeRepository: any CoffeeRepository
    public let favoritesRepository: any FavoritesRepository

    public init(coffeeRepository: any CoffeeRepository, favoritesRepository: any FavoritesRepository) {
        self.coffeeRepository = coffeeRepository
        self.favoritesRepository = favoritesRepository
    }

    /// Bundled catalog with a disk cache and favorites in `UserDefaults`.
    public static func live(api: BundledCoffeeAPI = BundledCoffeeAPI(latency: .milliseconds(500))) -> BrewDependencies {
        BrewDependencies(
            coffeeRepository: DefaultCoffeeRepository(api: api, cache: DiskCoffeeCache()),
            favoritesRepository: UserDefaultsFavoritesRepository()
        )
    }

    public static func preview(favorites: Set<Coffee.ID> = ["huila"]) -> BrewDependencies {
        BrewDependencies(
            coffeeRepository: InMemoryCoffeeRepository(),
            favoritesRepository: InMemoryFavoritesRepository(favorites)
        )
    }

    public var searchCoffees: SearchCoffeesUseCase {
        SearchCoffeesUseCase(repository: coffeeRepository)
    }

    public var toggleFavorite: ToggleFavoriteUseCase {
        ToggleFavoriteUseCase(favorites: favoritesRepository)
    }

    public var loadFavoriteCoffees: LoadFavoriteCoffeesUseCase {
        LoadFavoriteCoffeesUseCase(repository: coffeeRepository, favorites: favoritesRepository)
    }
}
