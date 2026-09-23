#if canImport(UIKit)
import BrewData
import BrewDomain
import Testing
import UIKit
@testable import MVVMCUIKit

@MainActor
struct OrderCoordinatorTests {
    @Test func walksThroughOptionsReviewAndConfirmation() async throws {
        let coordinator = OrderCoordinator(coffee: Coffee.samples[1], dependencies: .test())
        var finished = false
        coordinator.onFinish = { finished = true }
        coordinator.start()

        let options = try #require(coordinator.navigationController.topViewController as? OrderOptionsViewController)
        options.viewModel.quantity = 2
        options.viewModel.continueToReview()

        let review = try #require(coordinator.navigationController.topViewController as? OrderReviewViewController)
        #expect(review.viewModel.order == Order(coffee: Coffee.samples[1], quantity: 2))
        await review.viewModel.place()

        #expect(coordinator.navigationController.topViewController is OrderConfirmationViewController)
        #expect(!finished)
    }

    @Test func cancelFinishesTheFlow() throws {
        let coordinator = OrderCoordinator(coffee: Coffee.samples[0], dependencies: .test())
        var finished = false
        coordinator.onFinish = { finished = true }
        coordinator.start()

        let options = try #require(coordinator.navigationController.topViewController as? OrderOptionsViewController)
        options.viewModel.cancel()

        #expect(finished)
    }
}
#endif
