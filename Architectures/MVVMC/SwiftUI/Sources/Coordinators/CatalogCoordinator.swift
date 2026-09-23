import BrewData
import BrewDomain
import MVVMCViewModels
import Observation

/// Owns the catalog tab's stack. Anything outside the tab goes up to the parent through its callbacks.
@MainActor
@Observable
public final class CatalogCoordinator {
    public enum Route: Hashable {
        case detail(Coffee)
    }

    public var path: [Route] = []
    public let viewModel: CatalogViewModel

    @ObservationIgnored var onOrder: ((Coffee) -> Void)?
    @ObservationIgnored var onFavoritesChanged: (() async -> Void)?

    private let dependencies: BrewDependencies

    init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
        viewModel = CatalogViewModel(dependencies: dependencies)
        viewModel.onSelect = { [weak self] coffee in self?.path.append(.detail(coffee)) }
    }

    func show(_ coffee: Coffee) {
        path = [.detail(coffee)]
    }

    func makeDetailViewModel(for coffee: Coffee) -> CoffeeDetailViewModel {
        let detail = CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies)
        detail.onFavoriteChanged = { [weak self] in await self?.onFavoritesChanged?() }
        detail.onOrder = { [weak self] coffee in self?.onOrder?(coffee) }
        return detail
    }

    func favoritesDidChange() async {
        await viewModel.reloadFavorites()
    }
}
