public struct LoadFavoriteCoffeesUseCase: Sendable {
    private let repository: any CoffeeRepository
    private let favorites: any FavoritesRepository

    public init(repository: any CoffeeRepository, favorites: any FavoritesRepository) {
        self.repository = repository
        self.favorites = favorites
    }

    /// Favorites in catalog order. IDs of coffees that no longer exist are ignored.
    public func callAsFunction() async throws -> [Coffee] {
        let ids = await favorites.favoriteIDs()
        return try await repository.coffees().filter { ids.contains($0.id) }
    }
}
