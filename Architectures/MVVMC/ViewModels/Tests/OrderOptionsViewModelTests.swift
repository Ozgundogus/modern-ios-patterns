import BrewDomain
import Testing
@testable import MVVMCViewModels

@MainActor
struct OrderOptionsViewModelTests {
    @Test func buildsTheOrderFromTheChosenOptions() {
        let viewModel = OrderOptionsViewModel(coffee: Coffee.samples[1])
        var continued: [Order] = []
        viewModel.onContinue = { continued.append($0) }

        viewModel.size = .medium
        viewModel.grind = .espresso
        viewModel.quantity = 2
        viewModel.continueToReview()

        let expected = Order(coffee: Coffee.samples[1], size: .medium, grind: .espresso, quantity: 2)
        #expect(continued == [expected])
        #expect(viewModel.order.total == 56)
    }

    @Test func cancelIsReportedNotHandled() {
        let viewModel = OrderOptionsViewModel(coffee: Coffee.samples[0])
        var cancelled = false
        viewModel.onCancel = { cancelled = true }

        viewModel.cancel()

        #expect(cancelled)
    }
}
