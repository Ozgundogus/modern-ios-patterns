import BrewData
import BrewDomain

public struct DetailInteractor: DetailInteracting {
    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public func isFavorite(_ id: Coffee.ID) async -> Bool {
        await dependencies.favoritesRepository.favoriteIDs().contains(id)
    }

    public func toggleFavorite(_ id: Coffee.ID) async -> Bool {
        await dependencies.toggleFavorite(id)
    }
}
