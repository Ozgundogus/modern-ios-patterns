import BrewDomain

@MainActor
public final class FavoritesPresenter: FavoritesPresenting {
    public weak var view: (any FavoritesDisplaying)?

    private let interactor: any FavoritesInteracting
    private let router: any DetailRouting
    private var coffees: [Coffee] = []

    public init(interactor: any FavoritesInteracting, router: any DetailRouting) {
        self.interactor = interactor
        self.router = router
    }

    public func viewWillAppear() async {
        coffees = (try? await interactor.favoriteCoffees()) ?? []
        view?.display(coffees.map { CoffeeRowDisplayModel(coffee: $0, isFavorite: true) })
    }

    public func didSelectCoffee(id: String) {
        guard let coffee = coffees.first(where: { $0.id == id }) else { return }
        router.showDetail(for: coffee)
    }
}
