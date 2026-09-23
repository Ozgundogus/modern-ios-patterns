import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class CatalogViewModel {
    public var query = ""
    public var roast: Roast?
    public private(set) var coffees: [Coffee] = []
    public private(set) var favoriteIDs: Set<Coffee.ID> = []
    public private(set) var isLoading = false
    public private(set) var offlineMessage: String?

    private let dependencies: BrewDependencies
    private let router: any CatalogRouting

    public init(dependencies: BrewDependencies, router: any CatalogRouting) {
        self.dependencies = dependencies
        self.router = router
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
        favoriteIDs = await dependencies.favoritesRepository.favoriteIDs()
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

    public func isFavorite(_ coffee: Coffee) -> Bool {
        favoriteIDs.contains(coffee.id)
    }

    public func select(_ coffee: Coffee) {
        router.showDetail(for: coffee)
    }
}
