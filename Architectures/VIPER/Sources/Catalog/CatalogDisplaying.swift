/// Presenter → View.
@MainActor
public protocol CatalogDisplaying: AnyObject {
    func display(_ model: CatalogDisplayModel)
}
