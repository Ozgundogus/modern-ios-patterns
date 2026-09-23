import Foundation

extension DiscountStrategy {
    public struct Tier: Sendable {
        public let minimumSubtotal: Decimal
        public let percent: Decimal

        public init(minimumSubtotal: Decimal, percent: Decimal) {
            self.minimumSubtotal = minimumSubtotal
            self.percent = percent
        }
    }

    public static let noDiscount = DiscountStrategy(name: "No discount") { _ in 0 }

    public static func percentage(_ percent: Decimal) -> DiscountStrategy {
        DiscountStrategy(name: "\(percent)% off") { cart in
            cart.subtotal * percent / 100
        }
    }

    public static func fixedAmount(_ amount: Decimal) -> DiscountStrategy {
        DiscountStrategy(name: "\(amount.formatted(.currency(code: "USD"))) off") { _ in
            amount
        }
    }

    public static func buyXGetYFree(productID: String, buy: Int, free: Int) -> DiscountStrategy {
        DiscountStrategy(name: "Buy \(buy), get \(free) free") { cart in
            guard let item = cart.item(withID: productID) else { return 0 }
            let freeUnits = item.quantity / (buy + free) * free
            return item.unitPrice * Decimal(freeUnits)
        }
    }

    public static func tiered(_ tiers: [Tier]) -> DiscountStrategy {
        DiscountStrategy(name: "Spend more, save more") { cart in
            let tier = tiers
                .filter { cart.subtotal >= $0.minimumSubtotal }
                .max { $0.percent < $1.percent }
            guard let tier else { return 0 }
            return cart.subtotal * tier.percent / 100
        }
    }

    /// Combines strategies by picking whichever gives the customer the biggest discount.
    public static func best(of strategies: [DiscountStrategy]) -> DiscountStrategy {
        DiscountStrategy(name: "Best offer") { cart in
            strategies.map { $0.discount(for: cart) }.max() ?? 0
        }
    }
}
