#if canImport(UIKit)
import BrewData
import BrewDomain
import Foundation
import Testing
import UIKit
@testable import MVVMCUIKit

@MainActor
struct AppCoordinatorTests {
    /// The coordinator only holds the tab bar controller unowned, so the test keeps it alive.
    private func makeStartedCoordinator() -> (AppCoordinator, UITabBarController) {
        let tabBarController = UITabBarController()
        let coordinator = AppCoordinator(tabBarController: tabBarController, dependencies: .test())
        coordinator.start()
        return (coordinator, tabBarController)
    }

    @Test func startBuildsOneChildCoordinatorPerTab() {
        let (coordinator, tabBarController) = makeStartedCoordinator()

        #expect(coordinator.childCoordinators.count == 2)
        #expect(tabBarController.viewControllers?.first === coordinator.catalog.navigationController)
        #expect(tabBarController.viewControllers?.last === coordinator.favorites.navigationController)
        #expect(coordinator.catalog.navigationController.topViewController is CatalogViewController)
    }

    @Test func selectingACoffeePushesOntoThatTabsStackOnly() {
        let (coordinator, _) = makeStartedCoordinator()

        coordinator.catalog.viewModel.select(Coffee.samples[0])

        let detail = coordinator.catalog.navigationController.topViewController as? CoffeeDetailViewController
        #expect(detail?.viewModel.coffee == Coffee.samples[0])
        #expect(coordinator.favorites.navigationController.viewControllers.count == 1)
    }

    @Test func favoriteChangesInOneTabReachTheOther() async {
        let (coordinator, _) = makeStartedCoordinator()
        coordinator.catalog.viewModel.select(Coffee.samples[2])
        let detail = coordinator.catalog.navigationController.topViewController as? CoffeeDetailViewController

        await detail?.viewModel.toggleFavorite()

        #expect(coordinator.catalog.viewModel.isFavorite(Coffee.samples[2]))
        #expect(coordinator.favorites.viewModel.coffees.map(\.id) == ["sumatra"])
    }

    @Test func orderingFromADetailStartsAChildCoordinator() {
        let (coordinator, _) = makeStartedCoordinator()
        coordinator.favorites.viewModel.select(Coffee.samples[1])
        let detail = coordinator.favorites.navigationController.topViewController as? CoffeeDetailViewController

        detail?.viewModel.order()

        #expect(coordinator.childCoordinators.count == 3)
        #expect(coordinator.order?.navigationController.topViewController is OrderOptionsViewController)
    }

    @Test func finishingTheOrderFlowRemovesAndReleasesTheChild() {
        let (coordinator, _) = makeStartedCoordinator()
        weak var child: OrderCoordinator?

        autoreleasepool {
            coordinator.startOrder(for: Coffee.samples[0])
            child = coordinator.order
            child?.finish()
        }

        #expect(coordinator.childCoordinators.count == 2)
        #expect(child == nil)
    }

    @Test func swipingTheSheetDownAlsoRemovesTheChild() throws {
        let (coordinator, _) = makeStartedCoordinator()
        coordinator.startOrder(for: Coffee.samples[0])
        let child = try #require(coordinator.order)

        child.presentationControllerDidDismiss(try #require(child.navigationController.presentationController))

        #expect(coordinator.order == nil)
    }

    @Test func orderDeepLinkRoutesDownTheTree() async throws {
        let (coordinator, tabBarController) = makeStartedCoordinator()
        tabBarController.selectedIndex = 1

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/huila/order")))

        let detail = coordinator.catalog.navigationController.topViewController as? CoffeeDetailViewController
        #expect(handled)
        #expect(tabBarController.selectedViewController === coordinator.catalog.navigationController)
        #expect(detail?.viewModel.coffee == Coffee.samples[1])
        #expect(coordinator.order != nil)
    }
}
#endif
