import BrewDomain
import Foundation

extension Order {
    public var formattedTotal: String {
        total.formatted(.currency(code: "USD"))
    }

    public var summary: String {
        "\(quantity) × \(size.displayName), \(grind.displayName.lowercased())"
    }
}
