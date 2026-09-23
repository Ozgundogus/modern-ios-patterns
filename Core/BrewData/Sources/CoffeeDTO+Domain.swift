import BrewDomain
import Foundation

extension CoffeeDTO {
    /// `nil` for records the app can't show correctly (unknown roast, malformed price).
    func toDomain() -> Coffee? {
        guard
            let roast = Roast(rawValue: roast),
            let price = Decimal(string: priceUSD, locale: Locale(identifier: "en_US_POSIX"))
        else { return nil }

        return Coffee(
            id: id,
            name: name,
            origin: origin,
            roast: roast,
            tastingNotes: tastingNotes,
            price: price,
            summary: summary
        )
    }
}
