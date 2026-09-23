import Observation

@MainActor
@Observable
public final class CheckoutViewModel {
    public private(set) var items: [String] = []

    private let cart: CartStore
    private let logger: any AppLogger

    public init(cart: CartStore, logger: any AppLogger) {
        self.cart = cart
        self.logger = logger
    }

    public func add(_ item: String) async {
        await cart.add(item)
        items = await cart.items
        logger.log("Added \(item) to cart")
    }
}
