import Foundation
import Testing
@testable import Strategy

struct CheckoutSummaryTests {
    @Test func appliesTheStrategyToTheCart() {
        let summary = CheckoutSummary(cart: .sample, strategy: .percentage(10))

        #expect(summary.subtotal == 32)
        #expect(summary.discountName == "10% off")
        #expect(summary.discount == .exact("3.2"))
        #expect(summary.total == .exact("28.8"))
    }

    @Test func sameCartDifferentStrategies() {
        let totals = [DiscountStrategy.noDiscount, .fixedAmount(5), .percentage(50)]
            .map { CheckoutSummary(cart: .sample, strategy: $0).total }

        #expect(totals == [32, 27, 16])
    }
}
