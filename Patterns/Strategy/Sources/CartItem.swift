import Foundation

public struct CartItem: Sendable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let unitPrice: Decimal
    public let quantity: Int

    public init(id: String, name: String, unitPrice: Decimal, quantity: Int) {
        self.id = id
        self.name = name
        self.unitPrice = unitPrice
        self.quantity = quantity
    }

    public var total: Decimal {
        unitPrice * Decimal(quantity)
    }
}
