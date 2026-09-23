import Foundation

public struct Product: Sendable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let price: Decimal

    public init(id: Int, name: String, price: Decimal) {
        self.id = id
        self.name = name
        self.price = price
    }

    public var formattedPrice: String {
        price.formatted(.currency(code: "USD"))
    }

    public static let samples = [
        Product(id: 1, name: "Espresso", price: 3),
        Product(id: 2, name: "Flat White", price: 4.5),
        Product(id: 3, name: "Cold Brew", price: 5),
    ]
}

/// Parses `modernios://product/<id>`. Shared by the SwiftUI and UIKit coordinators.
public enum DeepLink {
    public static func productID(from url: URL) -> Int? {
        guard url.scheme == "modernios", url.host() == "product" else { return nil }
        return Int(url.lastPathComponent)
    }
}
