import BrewDomain
import Observation

@MainActor
@Observable
public final class CoffeeDetailViewModel {
    public private(set) var viewData: CoffeeDetailViewData?
    public private(set) var errorMessage: String?

    private let coffeeID: Coffee.ID
    private let loader: any CoffeeLoading
    private let favorites: any FavoritesReading
    private let toggler: any FavoriteToggling
    private var coffee: Coffee?

    public init(coffeeID: Coffee.ID, loader: any CoffeeLoading, favorites: any FavoritesReading, toggler: any FavoriteToggling) {
        self.coffeeID = coffeeID
        self.loader = loader
        self.favorites = favorites
        self.toggler = toggler
    }

    public func load() async {
        do {
            let coffee = try await loader.coffee(id: coffeeID)
            self.coffee = coffee
            viewData = CoffeeDetailViewData(coffee: coffee, isFavorite: await favorites.favoriteIDs().contains(coffeeID))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func toggleFavorite() async {
        guard let coffee else { return }
        let isFavorite = await toggler.toggleFavorite(coffeeID)
        viewData = CoffeeDetailViewData(coffee: coffee, isFavorite: isFavorite)
    }
}
