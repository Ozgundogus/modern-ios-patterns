#if canImport(UIKit)
import BrewData
import BrewDomain
import Testing
@testable import MVC

@MainActor
struct FavoritesViewControllerTests {
    @Test func listsFavoritesInCatalogOrder() async {
        let controller = FavoritesViewController(dependencies: .test(favorites: InMemoryFavoritesRepository(["sumatra", "yirgacheffe"])))
        controller.loadViewIfNeeded()

        await controller.reload()

        #expect(controller.coffees.map(\.id) == ["yirgacheffe", "sumatra"])
        #expect(controller.contentUnavailableConfiguration == nil)
    }
}
#endif
