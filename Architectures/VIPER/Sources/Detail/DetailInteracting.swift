import BrewDomain

public protocol DetailInteracting: Sendable {
    func isFavorite(_ id: Coffee.ID) async -> Bool
    func toggleFavorite(_ id: Coffee.ID) async -> Bool
}
