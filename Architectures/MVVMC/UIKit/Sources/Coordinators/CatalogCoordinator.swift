#if canImport(UIKit)
import BrewData
import BrewDomain
import MVVMCViewModels
import UIKit

/// Owns the catalog tab's navigation controller. Anything outside the tab goes up to the parent through its callbacks.
@MainActor
public final class CatalogCoordinator: Coordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    let viewModel: CatalogViewModel
    var onOrder: ((Coffee) -> Void)?
    var onFavoritesChanged: (() async -> Void)?

    private let dependencies: BrewDependencies

    public init(navigationController: UINavigationController, dependencies: BrewDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        viewModel = CatalogViewModel(dependencies: dependencies)
    }

    public func start() {
        viewModel.onSelect = { [weak self] coffee in self?.showDetail(for: coffee) }
        navigationController.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "cup.and.saucer"), tag: 0)
        navigationController.setViewControllers([CatalogViewController(viewModel: viewModel)], animated: false)
    }

    func showDetail(for coffee: Coffee) {
        let detail = CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies)
        detail.onFavoriteChanged = { [weak self] in await self?.onFavoritesChanged?() }
        detail.onOrder = { [weak self] coffee in self?.onOrder?(coffee) }
        navigationController.pushViewController(CoffeeDetailViewController(viewModel: detail), animated: true)
    }

    func show(_ coffee: Coffee) {
        navigationController.popToRootViewController(animated: false)
        showDetail(for: coffee)
    }

    func favoritesDidChange() async {
        await viewModel.reloadFavorites()
    }
}
#endif
