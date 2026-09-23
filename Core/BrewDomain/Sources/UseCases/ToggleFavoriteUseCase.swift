public struct ToggleFavoriteUseCase: Sendable {
    private let favorites: any FavoritesRepository

    public init(favorites: any FavoritesRepository) {
        self.favorites = favorites
    }

    /// Returns the new value.
    @discardableResult
    public func callAsFunction(_ id: Coffee.ID) async -> Bool {
        let isFavorite = await !favorites.favoriteIDs().contains(id)
        await favorites.setFavorite(isFavorite, for: id)
        return isFavorite
    }
}
