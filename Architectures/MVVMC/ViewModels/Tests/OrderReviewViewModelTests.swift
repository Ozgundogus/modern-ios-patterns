import BrewData
import BrewDomain
import Testing
@testable import MVVMCViewModels

@MainActor
struct OrderReviewViewModelTests {
    @Test func placingReportsTheConfirmation() async {
        let orders = InMemoryOrderService()
        let order = Order(coffee: Coffee.samples[0])
        let viewModel = OrderReviewViewModel(order: order, dependencies: .test(orders: orders))
        var confirmations: [OrderConfirmation] = []
        viewModel.onPlaced = { confirmations.append($0) }

        await viewModel.place()

        #expect(confirmations.map(\.number) == ["BR-1001"])
        #expect(await orders.placedOrders == [order])
        #expect(!viewModel.isPlacing)
    }

    @Test func failureStaysOnTheScreenWithAMessage() async {
        let orders = InMemoryOrderService()
        await orders.setReachable(false)
        let viewModel = OrderReviewViewModel(order: Order(coffee: Coffee.samples[0]), dependencies: .test(orders: orders))
        var placed = false
        viewModel.onPlaced = { _ in placed = true }

        await viewModel.place()

        #expect(!placed)
        #expect(viewModel.errorMessage == OrderError.unavailable.errorDescription)
    }
}
