import BrewData
import BrewDomain
import Foundation
import Observation

/// Owns navigation state and creates view models. View models never create or show each other.
@MainActor
@Observable
public final class AppCoordinator {
    public enum Tab: Hashable {
        case catalog
        case favorites
    }

    public enum Route: Hashable {
        case detail(Coffee)
    }

    public var selectedTab: Tab = .catalog
    public var catalogPath: [Route] = []
    public var favoritesPath: [Route] = []

    public let catalog: CatalogViewModel
    public let favorites: FavoritesViewModel

    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
        catalog = CatalogViewModel(dependencies: dependencies)
        favorites = FavoritesViewModel(dependencies: dependencies)

        catalog.onSelect = { [weak self] coffee in
            self?.catalogPath.append(.detail(coffee))
        }
        favorites.onSelect = { [weak self] coffee in
            self?.favoritesPath.append(.detail(coffee))
        }
    }

    public func makeDetailViewModel(for coffee: Coffee) -> CoffeeDetailViewModel {
        let detail = CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies)
        detail.onFavoriteChanged = { [weak self] in
            await self?.favoritesDidChange()
        }
        return detail
    }

    /// Opens `brew://coffee/<id>`: switches to the catalog and shows that coffee.
    @discardableResult
    public func open(_ url: URL) async -> Bool {
        guard
            url.scheme == "brew",
            url.host() == "coffee",
            let coffee = try? await dependencies.coffeeRepository.coffee(id: url.lastPathComponent)
        else { return false }

        selectedTab = .catalog
        catalogPath = [.detail(coffee)]
        return true
    }

    private func favoritesDidChange() async {
        await catalog.reloadFavorites()
        await favorites.load()
    }
}
