import BrewDomain
import Observation

@MainActor
@Observable
public final class FavoritesViewModel {
    public private(set) var rows: [CoffeeRowViewData] = []
    public private(set) var errorMessage: String?

    private let favorites: any FavoritesReading

    public init(favorites: any FavoritesReading) {
        self.favorites = favorites
    }

    public func load() async {
        do {
            rows = try await favorites.favoriteCoffees().map { CoffeeRowViewData(coffee: $0, isFavorite: true) }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
