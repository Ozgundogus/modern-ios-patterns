import BrewData
import BrewDomain

extension BrewDependencies {
    static func test(
        coffees: InMemoryCoffeeRepository = InMemoryCoffeeRepository(),
        favorites: InMemoryFavoritesRepository = InMemoryFavoritesRepository(),
        orders: InMemoryOrderService = InMemoryOrderService()
    ) -> BrewDependencies {
        BrewDependencies(coffeeRepository: coffees, favoritesRepository: favorites, orderService: orders)
    }
}
