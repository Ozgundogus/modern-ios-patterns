#if canImport(UIKit)
import BrewData
import BrewDomain
import Testing
@testable import MVC

/// MVC logic lives in view controllers, so these tests need UIKit and run on the iOS simulator.
@MainActor
struct CatalogViewControllerTests {
    @Test func showsTheCatalogSortedByName() async {
        let controller = CatalogViewController(dependencies: .test())
        controller.loadViewIfNeeded()

        await controller.reload()

        #expect(controller.visibleCoffeeIDs == ["huila", "sumatra", "yirgacheffe"])
    }

    @Test func failedRefreshKeepsTheListAndShowsAPrompt() async {
        let coffees = InMemoryCoffeeRepository()
        let controller = CatalogViewController(dependencies: .test(coffees: coffees))
        controller.loadViewIfNeeded()
        await controller.reload()
        await coffees.setReachable(false)

        await controller.refresh()

        #expect(controller.visibleCoffeeIDs.count == 3)
        #expect(controller.navigationItem.prompt == CoffeeError.unavailable.errorDescription)
    }
}
#endif
