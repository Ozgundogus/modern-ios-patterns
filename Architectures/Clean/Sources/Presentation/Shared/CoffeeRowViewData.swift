import BrewDomain
import BrewUI

/// Everything a row shows, already formatted. Views never see a `Coffee`.
public struct CoffeeRowViewData: Sendable, Equatable, Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let price: String
    public let isFavorite: Bool

    public init(coffee: Coffee, isFavorite: Bool) {
        id = coffee.id
        title = coffee.name
        subtitle = coffee.subtitle
        price = coffee.formattedPrice
        self.isFavorite = isFavorite
    }
}
