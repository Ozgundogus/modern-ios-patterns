import Foundation
@testable import Strategy

extension Cart {
    static func with(subtotal: Decimal) -> Cart {
        Cart(items: [CartItem(id: "item", name: "Item", unitPrice: subtotal, quantity: 1)])
    }

    static func espressos(_ quantity: Int) -> Cart {
        Cart(items: [CartItem(id: "espresso", name: "Espresso", unitPrice: 3, quantity: quantity)])
    }
}

extension Decimal {
    static func exact(_ value: String) -> Decimal {
        Decimal(string: value, locale: Locale(identifier: "en_US_POSIX"))!
    }
}
