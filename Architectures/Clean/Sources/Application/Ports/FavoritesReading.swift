import BrewDomain

public protocol FavoritesReading: Sendable {
    func favoriteIDs() async -> Set<Coffee.ID>
    func favoriteCoffees() async throws -> [Coffee]
}
