@testable import VIPER

@MainActor
final class SpyCatalogView: CatalogDisplaying {
    private(set) var displayed: [CatalogDisplayModel] = []

    func display(_ model: CatalogDisplayModel) {
        displayed.append(model)
    }
}
