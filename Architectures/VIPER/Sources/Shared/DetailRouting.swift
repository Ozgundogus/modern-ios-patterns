import BrewDomain

@MainActor
public protocol DetailRouting: AnyObject {
    func showDetail(for coffee: Coffee)
}
