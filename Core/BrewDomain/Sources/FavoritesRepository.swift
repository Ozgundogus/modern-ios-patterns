public protocol FavoritesRepository: Sendable {
    func favoriteIDs() async -> Set<Coffee.ID>
    func setFavorite(_ isFavorite: Bool, for id: Coffee.ID) async
}
