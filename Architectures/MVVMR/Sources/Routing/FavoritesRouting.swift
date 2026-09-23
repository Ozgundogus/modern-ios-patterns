import BrewDomain

@MainActor
public protocol FavoritesRouting: AnyObject {
    func showDetail(for coffee: Coffee)
}
