import BrewDomain

/// View → Presenter. The view reports events and never decides anything.
@MainActor
public protocol CatalogPresenting: AnyObject {
    func viewWillAppear() async
    func didChangeQuery(_ query: String) async
    func didSelectRoast(_ roast: Roast?) async
    func didPullToRefresh() async
    func didSelectCoffee(id: String)
}
