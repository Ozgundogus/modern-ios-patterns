import Foundation

public struct ProductRow: Sendable, Equatable, Decodable {
    public let name: String
    public let price: Decimal
    public let badge: String?

    public init(name: String, price: Decimal, badge: String? = nil) {
        self.name = name
        self.price = price
        self.badge = badge
    }
}
