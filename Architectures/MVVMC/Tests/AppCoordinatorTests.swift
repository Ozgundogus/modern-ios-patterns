import BrewData
import BrewDomain
import Foundation
import Testing
@testable import MVVMC

@MainActor
struct AppCoordinatorTests {
    @Test func selectingACoffeePushesItsDetail() {
        let coordinator = AppCoordinator(dependencies: .test())

        coordinator.catalog.select(Coffee.samples[0])

        #expect(coordinator.catalogPath == [.detail(Coffee.samples[0])])
        #expect(coordinator.favoritesPath.isEmpty)
    }

    @Test func eachTabHasItsOwnStack() {
        let coordinator = AppCoordinator(dependencies: .test())

        coordinator.favorites.select(Coffee.samples[1])

        #expect(coordinator.favoritesPath == [.detail(Coffee.samples[1])])
        #expect(coordinator.catalogPath.isEmpty)
    }

    @Test func favoriteChangesReachEveryScreenImmediately() async {
        let coordinator = AppCoordinator(dependencies: .test())
        await coordinator.catalog.load()
        await coordinator.favorites.load()

        await coordinator.makeDetailViewModel(for: Coffee.samples[2]).toggleFavorite()

        #expect(coordinator.catalog.isFavorite(Coffee.samples[2]))
        #expect(coordinator.favorites.coffees.map(\.id) == ["sumatra"])
    }

    @Test func deepLinkOpensTheCoffeeInTheCatalog() async throws {
        let coordinator = AppCoordinator(dependencies: .test())
        coordinator.selectedTab = .favorites

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/huila")))

        #expect(handled)
        #expect(coordinator.selectedTab == .catalog)
        #expect(coordinator.catalogPath == [.detail(Coffee.samples[1])])
    }

    @Test func unknownDeepLinkIsIgnored() async throws {
        let coordinator = AppCoordinator(dependencies: .test())

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/decaf")))

        #expect(!handled)
        #expect(coordinator.catalogPath.isEmpty)
    }
}
