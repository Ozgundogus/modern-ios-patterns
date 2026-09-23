import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class CoffeeDetailViewModel {
    public let coffee: Coffee
    public private(set) var isFavorite = false

    private let dependencies: BrewDependencies
    private let router: any DetailRouting

    public init(coffee: Coffee, dependencies: BrewDependencies, router: any DetailRouting) {
        self.coffee = coffee
        self.dependencies = dependencies
        self.router = router
    }

    public func load() async {
        isFavorite = await dependencies.favoritesRepository.favoriteIDs().contains(coffee.id)
    }

    public func toggleFavorite() async {
        isFavorite = await dependencies.toggleFavorite(coffee.id)
        if !isFavorite {
            router.didRemoveFavorite(coffee)
        }
    }
}
