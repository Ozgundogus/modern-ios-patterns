import BrewDomain

@MainActor
public protocol DetailRouting: AnyObject {
    func didRemoveFavorite(_ coffee: Coffee)
}
