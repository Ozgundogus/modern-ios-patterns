public struct OrderConfirmation: Sendable, Hashable, Identifiable {
    public let number: String
    public let order: Order

    public init(number: String, order: Order) {
        self.number = number
        self.order = order
    }

    public var id: String { number }
}
