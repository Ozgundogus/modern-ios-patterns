#if canImport(UIKit)
import BrewData
import BrewDomain
import Testing
@testable import MVC

@MainActor
struct CoffeeDetailViewControllerTests {
    @Test func togglesTheFavoriteAndUpdatesTheButton() async {
        let favorites = InMemoryFavoritesRepository()
        let controller = CoffeeDetailViewController(coffee: Coffee.samples[0], dependencies: .test(favorites: favorites))
        controller.loadViewIfNeeded()

        await controller.toggleFavorite()

        #expect(controller.isFavorite)
        #expect(controller.favoriteButton.configuration?.title == "Remove from favorites")
        #expect(await favorites.favoriteIDs() == ["yirgacheffe"])
    }
}
#endif
