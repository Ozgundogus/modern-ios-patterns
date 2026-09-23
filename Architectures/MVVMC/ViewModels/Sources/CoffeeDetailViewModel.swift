import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class CoffeeDetailViewModel {
    public let coffee: Coffee
    public private(set) var isFavorite = false

    @ObservationIgnored public var onFavoriteChanged: (() async -> Void)?
    @ObservationIgnored public var onOrder: ((Coffee) -> Void)?

    private let dependencies: BrewDependencies

    public init(coffee: Coffee, dependencies: BrewDependencies) {
        self.coffee = coffee
        self.dependencies = dependencies
    }

    public func load() async {
        isFavorite = await dependencies.favoritesRepository.favoriteIDs().contains(coffee.id)
    }

    public func toggleFavorite() async {
        isFavorite = await dependencies.toggleFavorite(coffee.id)
        await onFavoriteChanged?()
    }

    public func order() {
        onOrder?(coffee)
    }
}
