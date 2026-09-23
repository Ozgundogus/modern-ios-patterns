import BrewDomain

public protocol FavoriteToggling: Sendable {
    func toggleFavorite(_ id: Coffee.ID) async -> Bool
}
