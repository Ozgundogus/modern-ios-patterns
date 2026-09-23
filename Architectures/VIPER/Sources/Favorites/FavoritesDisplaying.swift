@MainActor
public protocol FavoritesDisplaying: AnyObject {
    func display(_ rows: [CoffeeRowDisplayModel])
}
