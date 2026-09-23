import BrewData
import BrewDomain
import Foundation
import MVVMCViewModels
import Observation

/// The root of the coordinator tree: one child per tab and, while an order is in progress, the order flow.
/// Children never talk to each other. They report here, and this coordinator decides who else needs to know.
@MainActor
@Observable
public final class AppCoordinator {
    public enum Tab: Hashable {
        case catalog
        case favorites
    }

    public var selectedTab: Tab = .catalog
    /// Presented as a sheet. Setting it to `nil`, which a swipe down also does, ends the flow and releases the child.
    public var order: OrderCoordinator?

    public let catalog: CatalogCoordinator
    public let favorites: FavoritesCoordinator

    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
        catalog = CatalogCoordinator(dependencies: dependencies)
        favorites = FavoritesCoordinator(dependencies: dependencies)

        catalog.onOrder = { [weak self] coffee in self?.startOrder(for: coffee) }
        catalog.onFavoritesChanged = { [weak self] in await self?.favoritesDidChange() }
        favorites.onOrder = { [weak self] coffee in self?.startOrder(for: coffee) }
        favorites.onFavoritesChanged = { [weak self] in await self?.favoritesDidChange() }
    }

    public func startOrder(for coffee: Coffee) {
        let child = OrderCoordinator(coffee: coffee, dependencies: dependencies)
        child.onFinish = { [weak self] in self?.order = nil }
        order = child
    }

    /// Opens `brew://coffee/<id>` and `brew://coffee/<id>/order` by routing down the tree.
    @discardableResult
    public func open(_ url: URL) async -> Bool {
        guard
            let link = DeepLink(url: url),
            let coffee = try? await dependencies.coffeeRepository.coffee(id: link.coffeeID)
        else { return false }

        order = nil
        selectedTab = .catalog
        catalog.show(coffee)
        if case .order = link {
            startOrder(for: coffee)
        }
        return true
    }

    private func favoritesDidChange() async {
        await catalog.favoritesDidChange()
        await favorites.favoritesDidChange()
    }
}
