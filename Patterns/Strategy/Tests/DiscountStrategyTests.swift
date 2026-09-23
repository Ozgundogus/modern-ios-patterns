import Foundation
import Testing
@testable import Strategy

struct DiscountStrategyTests {
    @Test func noDiscountTakesNothingOff() {
        #expect(DiscountStrategy.noDiscount.discount(for: .sample) == 0)
    }

    @Test func percentageIsTakenFromTheSubtotal() {
        #expect(DiscountStrategy.percentage(10).discount(for: .sample) == .exact("3.2"))
    }

    @Test func percentageIsRoundedToCents() {
        #expect(DiscountStrategy.percentage(15).discount(for: .with(subtotal: .exact("9.99"))) == .exact("1.5"))
    }

    @Test func fixedAmountNeverExceedsTheSubtotal() {
        #expect(DiscountStrategy.fixedAmount(5).discount(for: .sample) == 5)
        #expect(DiscountStrategy.fixedAmount(50).discount(for: .sample) == 32)
    }

    @Test(arguments: [(2, 0), (3, 3), (5, 3), (6, 6), (7, 6)] as [(Int, Decimal)])
    func buyTwoGetOneFree(quantity: Int, expected: Decimal) {
        let strategy = DiscountStrategy.buyXGetYFree(productID: "espresso", buy: 2, free: 1)

        #expect(strategy.discount(for: .espressos(quantity)) == expected)
    }

    @Test func buyXGetYFreeIgnoresOtherProducts() {
        let strategy = DiscountStrategy.buyXGetYFree(productID: "croissant", buy: 1, free: 1)

        #expect(strategy.discount(for: .espressos(4)) == 0)
    }

    @Test(arguments: [("29", "0"), ("30", "1.5"), ("59", "2.95"), ("60", "6"), ("120", "12")])
    func tieredUsesTheHighestReachedTier(subtotal: String, expected: String) {
        let strategy = DiscountStrategy.tiered([
            .init(minimumSubtotal: 30, percent: 5),
            .init(minimumSubtotal: 60, percent: 10),
        ])

        #expect(strategy.discount(for: .with(subtotal: .exact(subtotal))) == .exact(expected))
    }

    @Test func bestOfPicksTheBiggestDiscount() {
        let strategy = DiscountStrategy.best(of: [.percentage(10), .fixedAmount(5), .noDiscount])

        #expect(strategy.discount(for: .sample) == 5)
        #expect(strategy.discount(for: .with(subtotal: 100)) == 10)
    }
}
