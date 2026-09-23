@testable import BrewDomain

actor InMemoryFavoritesRepository: FavoritesRepository {
    private var ids: Set<Coffee.ID>

    init(_ ids: Set<Coffee.ID> = []) {
        self.ids = ids
    }

    func favoriteIDs() -> Set<Coffee.ID> {
        ids
    }

    func setFavorite(_ isFavorite: Bool, for id: Coffee.ID) {
        if isFavorite {
            ids.insert(id)
        } else {
            ids.remove(id)
        }
    }
}
