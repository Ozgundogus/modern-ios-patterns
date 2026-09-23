import BrewData
import BrewDomain

extension BrewDependencies {
    static func test(
        coffees: InMemoryCoffeeRepository = InMemoryCoffeeRepository(),
        favorites: InMemoryFavoritesRepository = InMemoryFavoritesRepository()
    ) -> BrewDependencies {
        BrewDependencies(coffeeRepository: coffees, favoritesRepository: favorites)
    }
}
