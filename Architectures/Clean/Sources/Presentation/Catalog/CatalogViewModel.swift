import BrewDomain
import Observation

@MainActor
@Observable
public final class CatalogViewModel {
    public var query = ""
    public var roast: Roast?
    public private(set) var rows: [CoffeeRowViewData] = []
    public private(set) var isLoading = false
    public private(set) var offlineMessage: String?

    private let catalog: any CoffeeSearching
    private let favorites: any FavoritesReading

    public init(catalog: any CoffeeSearching, favorites: any FavoritesReading) {
        self.catalog = catalog
        self.favorites = favorites
    }

    public var searchKey: [String] {
        [query, roast?.rawValue ?? ""]
    }

    public func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let coffees = try await catalog.search(query: query, roast: roast)
            let favoriteIDs = await favorites.favoriteIDs()
            rows = coffees.map { CoffeeRowViewData(coffee: $0, isFavorite: favoriteIDs.contains($0.id)) }
        } catch {
            offlineMessage = error.localizedDescription
        }
    }

    public func refresh() async {
        do {
            try await catalog.refreshCatalog()
            offlineMessage = nil
        } catch {
            offlineMessage = error.localizedDescription
            return
        }
        await load()
    }
}
