import BrewDomain
import Observation

/// The first step of the order flow. It reports the order it built through `onContinue`.
@MainActor
@Observable
public final class OrderOptionsViewModel {
    public var size: Order.Size = .small
    public var grind: Order.Grind = .wholeBean
    public var quantity = 1

    public let coffee: Coffee

    @ObservationIgnored public var onContinue: ((Order) -> Void)?
    @ObservationIgnored public var onCancel: (() -> Void)?

    public init(coffee: Coffee) {
        self.coffee = coffee
    }

    public var order: Order {
        Order(coffee: coffee, size: size, grind: grind, quantity: quantity)
    }

    public func continueToReview() {
        onContinue?(order)
    }

    public func cancel() {
        onCancel?()
    }
}
