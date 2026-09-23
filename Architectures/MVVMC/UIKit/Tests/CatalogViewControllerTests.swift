#if canImport(UIKit)
import BrewData
import BrewDomain
import MVVMCViewModels
import Testing
import UIKit
@testable import MVVMCUIKit

@MainActor
struct CatalogViewControllerTests {
    @Test func redrawsWhenTheViewModelChanges() async {
        let favorites = InMemoryFavoritesRepository()
        let viewModel = CatalogViewModel(dependencies: .test(favorites: favorites))
        let controller = CatalogViewController(viewModel: viewModel)
        controller.loadViewIfNeeded()

        await viewModel.load()
        #expect(await eventually { controller.visibleCoffeeIDs == ["huila", "sumatra", "yirgacheffe"] })

        await favorites.setFavorite(true, for: "huila")
        await viewModel.reloadFavorites()
        #expect(await eventually { controller.favoriteRowIDs == ["huila"] })
    }
}

/// `observe` redraws on the next main-actor turn, so give it a few turns.
@MainActor
private func eventually(_ condition: () -> Bool) async -> Bool {
    for _ in 0..<100 where !condition() {
        await Task.yield()
    }
    return condition()
}
#endif
