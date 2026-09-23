import BrewDomain

@MainActor
public protocol CatalogRouting: AnyObject {
    func showDetail(for coffee: Coffee)
}
