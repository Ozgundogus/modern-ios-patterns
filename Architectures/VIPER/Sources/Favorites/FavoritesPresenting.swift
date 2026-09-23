@MainActor
public protocol FavoritesPresenting: AnyObject {
    func viewWillAppear() async
    func didSelectCoffee(id: String)
}
