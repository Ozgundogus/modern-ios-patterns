import BrewDomain
import Foundation

/// The Composition Root for every Brew app. Presentation layers only see the domain protocols.
public struct BrewDependencies: Sendable {
    public let coffeeRepository: any CoffeeRepository
    public let favoritesRepository: any FavoritesRepository
    public let orderService: any OrderService

    public init(
        coffeeRepository: any CoffeeRepository,
        favoritesRepository: any FavoritesRepository,
        orderService: any OrderService = InMemoryOrderService()
    ) {
        self.coffeeRepository = coffeeRepository
        self.favoritesRepository = favoritesRepository
        self.orderService = orderService
    }

    /// Bundled catalog with a disk cache and favorites in `UserDefaults`.
    public static func live(api: BundledCoffeeAPI = BundledCoffeeAPI(latency: .milliseconds(500))) -> BrewDependencies {
        BrewDependencies(
            coffeeRepository: DefaultCoffeeRepository(api: api, cache: DiskCoffeeCache()),
            favoritesRepository: UserDefaultsFavoritesRepository(),
            orderService: InMemoryOrderService(latency: .seconds(1))
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

    public var placeOrder: PlaceOrderUseCase {
        PlaceOrderUseCase(service: orderService)
    }
}
