import BrewData
import BrewDomain
import Observation

/// Knows nothing about navigation. It reports what the user picked through `onSelect`.
@MainActor
@Observable
public final class CatalogViewModel {
    public var query = ""
    public var roast: Roast?
    public private(set) var coffees: [Coffee] = []
    public private(set) var favoriteIDs: Set<Coffee.ID> = []
    public private(set) var isLoading = false
    public private(set) var offlineMessage: String?

    @ObservationIgnored public var onSelect: ((Coffee) -> Void)?

    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public var searchKey: [String] {
        [query, roast?.rawValue ?? ""]
    }

    public func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            coffees = try await dependencies.searchCoffees(query: query, roast: roast)
        } catch {
            offlineMessage = error.localizedDescription
        }
        await reloadFavorites()
    }

    public func refresh() async {
        do {
            _ = try await dependencies.coffeeRepository.refresh()
            offlineMessage = nil
        } catch {
            offlineMessage = error.localizedDescription
            return
        }
        await load()
    }

    public func reloadFavorites() async {
        favoriteIDs = await dependencies.favoritesRepository.favoriteIDs()
    }

    public func isFavorite(_ coffee: Coffee) -> Bool {
        favoriteIDs.contains(coffee.id)
    }

    public func select(_ coffee: Coffee) {
        onSelect?(coffee)
    }
}
