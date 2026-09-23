import BrewDomain
import BrewUI

public struct CoffeeRowDisplayModel: Sendable, Equatable {
    public let id: String
    public let title: String
    public let subtitle: String

    public init(coffee: Coffee, isFavorite: Bool) {
        id = coffee.id
        title = isFavorite ? "\(coffee.name) ♥︎" : coffee.name
        subtitle = "\(coffee.subtitle) · \(coffee.formattedPrice)"
    }
}
