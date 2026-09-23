import BrewDomain

public actor InMemoryFavoritesRepository: FavoritesRepository {
    private var ids: Set<Coffee.ID>

    public init(_ ids: Set<Coffee.ID> = []) {
        self.ids = ids
    }

    public func favoriteIDs() -> Set<Coffee.ID> {
        ids
    }

    public func setFavorite(_ isFavorite: Bool, for id: Coffee.ID) {
        if isFavorite {
            ids.insert(id)
        } else {
            ids.remove(id)
        }
    }
}
