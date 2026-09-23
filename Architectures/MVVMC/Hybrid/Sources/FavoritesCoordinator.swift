#if canImport(UIKit)
import BrewData
import BrewDomain
import MVVMCViewModels
import SwiftUI
import UIKit
import protocol MVVMCUIKit.Coordinator
import struct MVVMCSwiftUI.CoffeeDetailView
import struct MVVMCSwiftUI.FavoritesView

/// A fully migrated tab: SwiftUI screens, still pushed by a UIKit navigation controller.
@MainActor
public final class FavoritesCoordinator: Coordinator {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController: UINavigationController

    let viewModel: FavoritesViewModel
    var onOrder: ((Coffee) -> Void)?
    var onFavoritesChanged: (() async -> Void)?

    private let dependencies: BrewDependencies

    public init(navigationController: UINavigationController, dependencies: BrewDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        viewModel = FavoritesViewModel(dependencies: dependencies)
    }

    public func start() {
        viewModel.onSelect = { [weak self] coffee in self?.showDetail(for: coffee) }
        navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
        navigationController.setViewControllers([UIHostingController(rootView: FavoritesView(viewModel: viewModel))], animated: false)
    }

    func showDetail(for coffee: Coffee) {
        let detail = CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies)
        detail.onFavoriteChanged = { [weak self] in await self?.onFavoritesChanged?() }
        detail.onOrder = { [weak self] coffee in self?.onOrder?(coffee) }
        navigationController.pushViewController(UIHostingController(rootView: CoffeeDetailView(viewModel: detail)), animated: true)
    }

    func favoritesDidChange() async {
        await viewModel.load()
    }
}
#endif
