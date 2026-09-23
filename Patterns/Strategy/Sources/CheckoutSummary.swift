import Foundation

public struct CheckoutSummary: Sendable, Equatable {
    public let subtotal: Decimal
    public let discountName: String
    public let discount: Decimal
    public let total: Decimal

    public init(cart: Cart, strategy: DiscountStrategy) {
        subtotal = cart.subtotal
        discountName = strategy.name
        discount = strategy.discount(for: cart)
        total = subtotal - discount
    }
}
