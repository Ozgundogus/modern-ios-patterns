public struct NewOrder: Sendable, Encodable {
    public let productID: Int
    public let quantity: Int

    public init(productID: Int, quantity: Int) {
        self.productID = productID
        self.quantity = quantity
    }
}
