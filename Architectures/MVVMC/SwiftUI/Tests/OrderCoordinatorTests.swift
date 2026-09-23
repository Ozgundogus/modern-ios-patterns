import BrewData
import BrewDomain
import Testing
@testable import MVVMCSwiftUI

@MainActor
struct OrderCoordinatorTests {
    @Test func walksThroughOptionsReviewAndConfirmation() async {
        let orders = InMemoryOrderService()
        let coordinator = OrderCoordinator(coffee: Coffee.samples[1], dependencies: .test(orders: orders))
        var finished = false
        coordinator.onFinish = { finished = true }
        let order = Order(coffee: Coffee.samples[1], quantity: 2)

        coordinator.options.quantity = 2
        coordinator.options.continueToReview()
        #expect(coordinator.path == [.review(order)])

        await coordinator.makeReviewViewModel(for: order).place()
        #expect(coordinator.path.last == .confirmation(OrderConfirmation(number: "BR-1001", order: order)))
        #expect(!finished)

        coordinator.finish()
        #expect(finished)
    }

    @Test func cancellingFinishesWithoutPlacingAnOrder() async {
        let orders = InMemoryOrderService()
        let coordinator = OrderCoordinator(coffee: Coffee.samples[0], dependencies: .test(orders: orders))
        var finished = false
        coordinator.onFinish = { finished = true }

        coordinator.options.cancel()

        #expect(finished)
        #expect(await orders.placedOrders.isEmpty)
    }
}
