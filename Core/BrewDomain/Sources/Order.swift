import Foundation

public struct Order: Sendable, Hashable {
    public enum Size: Int, Sendable, CaseIterable, Identifiable {
        case small = 250
        case medium = 500
        case large = 1000

        public var id: Int { rawValue }

        public var displayName: String {
            rawValue < 1000 ? "\(rawValue) g" : "\(rawValue / 1000) kg"
        }

        /// Catalog prices are per 250 g bag.
        public var priceMultiplier: Decimal {
            Decimal(rawValue / Size.small.rawValue)
        }
    }

    public enum Grind: String, Sendable, CaseIterable, Identifiable {
        case wholeBean
        case espresso
        case filter
        case frenchPress

        public var id: String { rawValue }

        public var displayName: String {
            switch self {
            case .wholeBean: "Whole bean"
            case .espresso: "Espresso"
            case .filter: "Filter"
            case .frenchPress: "French press"
            }
        }
    }

    public static let quantityRange = 1...10

    public let coffee: Coffee
    public var size: Size
    public var grind: Grind
    public var quantity: Int

    public init(coffee: Coffee, size: Size = .small, grind: Grind = .wholeBean, quantity: Int = 1) {
        self.coffee = coffee
        self.size = size
        self.grind = grind
        self.quantity = quantity
    }

    public var total: Decimal {
        coffee.price * size.priceMultiplier * Decimal(quantity)
    }
}
