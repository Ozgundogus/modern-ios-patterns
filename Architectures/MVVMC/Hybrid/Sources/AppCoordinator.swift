#if canImport(UIKit)
import BrewData
import BrewDomain
import Foundation
import MVVMCViewModels
import UIKit
import protocol MVVMCUIKit.Coordinator

/// Identical to the UIKit version: the coordinator tree doesn't care which framework draws each screen.
@MainActor
public final class AppCoordinator: Coordinator {
    public var childCoordinators: [any Coordinator] = []

    let catalog: CatalogCoordinator
    let favorites: FavoritesCoordinator

    private unowned let tabBarController: UITabBarController
    private let dependencies: BrewDependencies

    public init(tabBarController: UITabBarController, dependencies: BrewDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
        catalog = CatalogCoordinator(navigationController: UINavigationController(), dependencies: dependencies)
        favorites = FavoritesCoordinator(navigationController: UINavigationController(), dependencies: dependencies)
    }

    public func start() {
        catalog.onOrder = { [weak self] coffee in self?.startOrder(for: coffee) }
        catalog.onFavoritesChanged = { [weak self] in await self?.favoritesDidChange() }
        favorites.onOrder = { [weak self] coffee in self?.startOrder(for: coffee) }
        favorites.onFavoritesChanged = { [weak self] in await self?.favoritesDidChange() }

        startChild(catalog)
        startChild(favorites)
        tabBarController.viewControllers = [catalog.navigationController, favorites.navigationController]
    }

    var order: OrderCoordinator? {
        childCoordinators.lazy.compactMap { $0 as? OrderCoordinator }.first
    }

    func startOrder(for coffee: Coffee) {
        guard order == nil else { return }
        let child = OrderCoordinator(coffee: coffee, dependencies: dependencies)
        child.onFinish = { [weak self, weak child] in
            guard let self, let child else { return }
            finishOrder(child, animated: true)
        }
        startChild(child)
        tabBarController.present(child.navigationController, animated: true)
    }

    @discardableResult
    public func open(_ url: URL) async -> Bool {
        guard
            let link = DeepLink(url: url),
            let coffee = try? await dependencies.coffeeRepository.coffee(id: link.coffeeID)
        else { return false }

        if let order {
            finishOrder(order, animated: false)
        }
        tabBarController.selectedViewController = catalog.navigationController
        catalog.show(coffee)
        if case .order = link {
            startOrder(for: coffee)
        }
        return true
    }

    private func finishOrder(_ child: OrderCoordinator, animated: Bool) {
        if tabBarController.presentedViewController === child.navigationController {
            tabBarController.dismiss(animated: animated)
        }
        removeChild(child)
    }

    private func favoritesDidChange() async {
        await catalog.favoritesDidChange()
        await favorites.favoritesDidChange()
    }
}
#endif
