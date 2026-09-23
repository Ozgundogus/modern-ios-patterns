import BrewDomain

public protocol FavoritesInteracting: Sendable {
    func favoriteCoffees() async throws -> [Coffee]
}
