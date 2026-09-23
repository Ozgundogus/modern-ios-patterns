import Foundation

/// A pricing rule stored as a value: a name and a `@Sendable` closure.
/// New rules are new values, not new subclasses, so call sites read `.percentage(10)`.
public struct DiscountStrategy: Sendable {
    public let name: String
    private let calculate: @Sendable (Cart) -> Decimal

    public init(name: String, calculate: @escaping @Sendable (Cart) -> Decimal) {
        self.name = name
        self.calculate = calculate
    }

    /// Never negative and never more than the subtotal, rounded to cents.
    public func discount(for cart: Cart) -> Decimal {
        min(max(calculate(cart), 0), cart.subtotal).rounded()
    }
}
