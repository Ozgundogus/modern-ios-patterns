import Foundation
import Testing
@testable import Coordinator

@MainActor
struct ShopCoordinatorTests {
    @Test func startsAtTheRoot() {
        let coordinator = ShopCoordinator()

        #expect(coordinator.path.isEmpty)
        #expect(coordinator.sheet == nil)
    }

    @Test func selectingAProductPushesItsDetail() {
        let coordinator = ShopCoordinator()

        coordinator.showProduct(.espresso)

        #expect(coordinator.path == [.product(.espresso)])
    }

    @Test func checkoutWhileLoggedOutAsksToLogInFirst() {
        let coordinator = ShopCoordinator(isLoggedIn: false)
        coordinator.showProduct(.espresso)

        coordinator.startCheckout(for: .espresso)

        #expect(coordinator.sheet == .login)
        #expect(coordinator.path == [.product(.espresso)])
    }

    @Test func loggingInContinuesToCheckout() {
        let coordinator = ShopCoordinator(isLoggedIn: false)
        coordinator.showProduct(.espresso)
        coordinator.startCheckout(for: .espresso)

        coordinator.didLogIn()

        #expect(coordinator.sheet == nil)
        #expect(coordinator.isLoggedIn)
        #expect(coordinator.path == [.product(.espresso), .checkout(.espresso)])
    }

    @Test func cancellingLoginStaysOnTheProduct() {
        let coordinator = ShopCoordinator(isLoggedIn: false)
        coordinator.showProduct(.espresso)
        coordinator.startCheckout(for: .espresso)

        coordinator.didCancelLogin()
        coordinator.didLogIn()

        #expect(coordinator.path == [.product(.espresso)])
    }

    @Test func checkoutWhileLoggedInGoesStraightThrough() {
        let coordinator = ShopCoordinator(isLoggedIn: true)
        coordinator.showProduct(.espresso)

        coordinator.startCheckout(for: .espresso)

        #expect(coordinator.sheet == nil)
        #expect(coordinator.path == [.product(.espresso), .checkout(.espresso)])
    }

    @Test func finishingAnOrderReturnsToTheRoot() {
        let coordinator = ShopCoordinator(isLoggedIn: true)
        coordinator.showProduct(.espresso)
        coordinator.startCheckout(for: .espresso)
        coordinator.didPlaceOrder(for: .espresso)
        #expect(coordinator.path.last == .confirmation(.espresso))

        coordinator.finish()

        #expect(coordinator.path.isEmpty)
    }

    @Test func deepLinkReplacesTheStack() throws {
        let coordinator = ShopCoordinator(isLoggedIn: true)
        coordinator.showProduct(.espresso)
        coordinator.startCheckout(for: .espresso)

        let handled = coordinator.handle(try #require(URL(string: "modernios://product/3")))

        #expect(handled)
        #expect(coordinator.path == [.product(.coldBrew)])
    }

    @Test func unknownDeepLinkIsIgnored() throws {
        let coordinator = ShopCoordinator()
        coordinator.showProduct(.espresso)

        let handled = coordinator.handle(try #require(URL(string: "modernios://product/999")))

        #expect(!handled)
        #expect(coordinator.path == [.product(.espresso)])
    }
}
