#if canImport(UIKit)
import BrewData
import BrewDomain
import Foundation
import SwiftUI
import Testing
import UIKit
import class MVVMCUIKit.CatalogViewController
import struct MVVMCSwiftUI.CoffeeDetailView
import struct MVVMCSwiftUI.FavoritesView
import struct MVVMCSwiftUI.OrderOptionsView
@testable import MVVMCHybrid

@MainActor
struct AppCoordinatorTests {
    private func makeStartedCoordinator(_ dependencies: BrewDependencies = .test()) -> (AppCoordinator, UITabBarController) {
        let tabBarController = UITabBarController()
        let coordinator = AppCoordinator(tabBarController: tabBarController, dependencies: dependencies)
        coordinator.start()
        return (coordinator, tabBarController)
    }

    @Test func legacyCatalogPushesAMigratedDetail() {
        let (coordinator, _) = makeStartedCoordinator()
        let navigationController = coordinator.catalog.navigationController

        #expect(navigationController.viewControllers.first is CatalogViewController)

        coordinator.catalog.viewModel.select(Coffee.samples[0])

        #expect(navigationController.topViewController is UIHostingController<CoffeeDetailView>)
    }

    @Test func favoritesTabIsSwiftUIInsideAUIKitStack() {
        let (coordinator, _) = makeStartedCoordinator()

        #expect(coordinator.favorites.navigationController.viewControllers.first is UIHostingController<FavoritesView>)
    }

    @Test func orderFlowIsSwiftUIDrivenByAUIKitChildCoordinator() {
        let (coordinator, _) = makeStartedCoordinator()

        coordinator.startOrder(for: Coffee.samples[1])

        #expect(coordinator.childCoordinators.count == 3)
        #expect(coordinator.order?.navigationController.topViewController is UIHostingController<OrderOptionsView>)
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

    @Test func favoriteChangesFromASwiftUITabReachTheLegacyCatalog() async {
        let favorites = InMemoryFavoritesRepository()
        let (coordinator, _) = makeStartedCoordinator(.test(favorites: favorites))
        await favorites.setFavorite(true, for: "huila")

        await coordinator.favorites.onFavoritesChanged?()

        #expect(coordinator.catalog.viewModel.favoriteIDs == ["huila"])
    }

    @Test func orderDeepLinkRoutesDownTheTree() async throws {
        let (coordinator, tabBarController) = makeStartedCoordinator()
        tabBarController.selectedIndex = 1

        let handled = await coordinator.open(try #require(URL(string: "brew://coffee/huila/order")))

        #expect(handled)
        #expect(tabBarController.selectedViewController === coordinator.catalog.navigationController)
        #expect(coordinator.catalog.navigationController.topViewController is UIHostingController<CoffeeDetailView>)
        #expect(coordinator.order != nil)
    }
}
#endif
