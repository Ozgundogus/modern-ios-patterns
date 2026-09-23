import BrewDomain

/// Holds the screen state, asks the interactor for data, formats it for the view
/// and asks the router to navigate. No UIKit import, so it's tested like plain Swift.
@MainActor
public final class CatalogPresenter: CatalogPresenting {
    public weak var view: (any CatalogDisplaying)?

    private let interactor: any CatalogInteracting
    private let router: any DetailRouting
    private var query = ""
    private var roast: Roast?
    private var coffees: [Coffee] = []
    private var favoriteIDs: Set<Coffee.ID> = []
    private var offlineMessage: String?

    public init(interactor: any CatalogInteracting, router: any DetailRouting) {
        self.interactor = interactor
        self.router = router
    }

    public func viewWillAppear() async {
        await load()
    }

    public func didChangeQuery(_ query: String) async {
        self.query = query
        await load()
    }

    public func didSelectRoast(_ roast: Roast?) async {
        self.roast = roast
        await load()
    }

    public func didPullToRefresh() async {
        do {
            try await interactor.refreshCatalog()
            offlineMessage = nil
        } catch {
            offlineMessage = error.localizedDescription
            render()
            return
        }
        await load()
    }

    public func didSelectCoffee(id: String) {
        guard let coffee = coffees.first(where: { $0.id == id }) else { return }
        router.showDetail(for: coffee)
    }

    private func load() async {
        do {
            coffees = try await interactor.searchCoffees(query: query, roast: roast)
        } catch {
            offlineMessage = error.localizedDescription
        }
        favoriteIDs = await interactor.favoriteIDs()
        render()
    }

    private func render() {
        view?.display(CatalogDisplayModel(
            rows: coffees.map { CoffeeRowDisplayModel(coffee: $0, isFavorite: favoriteIDs.contains($0.id)) },
            offlineMessage: offlineMessage
        ))
    }
}
