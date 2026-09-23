import BrewDomain
@testable import MVVMR

@MainActor
final class SpyRouter: CatalogRouting, FavoritesRouting, DetailRouting {
    private(set) var shownDetails: [Coffee] = []
    private(set) var removedFavorites: [Coffee] = []

    func showDetail(for coffee: Coffee) {
        shownDetails.append(coffee)
    }

    func didRemoveFavorite(_ coffee: Coffee) {
        removedFavorites.append(coffee)
    }
}
