import BrewData
import BrewDomain
import Foundation
import Testing
@testable import MVVMCSwiftUI

@MainActor
struct AppCoordinatorTests {
    @Test func selectingACoffeePushesOntoThatTabsStackOnly() {
        let coordinator = AppCoordinator(dependencies: .test())

        coordinator.catalog.viewModel.select(Coffee.samples[0])

        #expect(coordinator.catalog.path == [.detail(Coffee.samples[0])])
        #expect(coordinator.favorites.path.isEmpty)
    }

    @Test func favoriteChangesInOneTabReachTheOther() async {
        let coordinator = AppCoordinator(dependencies: .test())
        await coordinator.catalog.viewModel.load()
        await coordinator.favorites.viewModel.load()

        await coordinator.catalog.makeDetailViewModel(for: Coffee.samples[2]).toggleFavorite()

        #expect(coordinator.catalog.viewModel.isFavorite(Coffee.samples[2]))
        #expect(coordinator.favorites.viewModel.coffees.map(\.id) == ["sumatra"])
    }

    @Test(arguments: [false, true])
    func orderingFromEitherTabStartsTheOrderFlow(fromFavorites: Bool) {
        let coordinator = AppCoordinator(dependencies: .test())
        let detail = fromFavorites
            ? coordinator.favorites.makeDetailViewModel(for: Coffee.samples[1])
            : coordinator.catalog.makeDetailViewModel(for: Coffee.samples[1])

        detail.order()

        #expect(coordinator.order?.options.coffee == Coffee.samples[1])
    }

    @Test func finishingTheOrderFlowReleasesTheChild() {
        let coordinator = AppCoordinator(dependencies: .test())
        coordinator.startOrder(for: Coffee.samples[0])
        weak var child = coordinator.order

        child?.options.cancel()

        #expect(coordinator.order == nil)
        #expect(child == nil)
    }

    @Test func swipingTheSheetDownAlsoReleasesTheChild() {
        let coordinator = AppCoordinator(dependencies: .test())
        coordinator.startOrder(for: Coffee.samples[0])
        weak var child = coordinator.order

        coordinator.order = nil

        #expect(child == nil)
    }

    @Test func deepLinkRoutesDownToTheCatalog() async throws {
        let coordinator = AppCoordinator(dependencies: .test())
        coordinator.selectedTab = .favorites

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/huila")))

        #expect(handled)
        #expect(coordinator.selectedTab == .catalog)
        #expect(coordinator.catalog.path == [.detail(Coffee.samples[1])])
        #expect(coordinator.order == nil)
    }

    @Test func orderDeepLinkShowsTheCoffeeAndStartsTheOrderFlow() async throws {
        let coordinator = AppCoordinator(dependencies: .test())

        await coordinator.open(try #require(URL(string: "brew://coffee/sumatra/order")))

        #expect(coordinator.catalog.path == [.detail(Coffee.samples[2])])
        #expect(coordinator.order?.options.coffee == Coffee.samples[2])
    }

    @Test func unknownDeepLinkIsIgnored() async throws {
        let coordinator = AppCoordinator(dependencies: .test())

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/decaf")))

        #expect(!handled)
        #expect(coordinator.catalog.path.isEmpty)
    }
}
