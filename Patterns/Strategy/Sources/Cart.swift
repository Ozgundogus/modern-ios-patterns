import Foundation

public struct Cart: Sendable, Equatable {
    public var items: [CartItem]

    public init(items: [CartItem] = []) {
        self.items = items
    }

    public var subtotal: Decimal {
        items.reduce(0) { $0 + $1.total }
    }

    public func item(withID id: String) -> CartItem? {
        items.first { $0.id == id }
    }
}

extension Cart {
    public static let sample = Cart(items: [
        CartItem(id: "espresso", name: "Espresso", unitPrice: 3, quantity: 3),
        CartItem(id: "croissant", name: "Croissant", unitPrice: 2.5, quantity: 2),
        CartItem(id: "beans", name: "Coffee Beans 1kg", unitPrice: 18, quantity: 1),
    ])
}
