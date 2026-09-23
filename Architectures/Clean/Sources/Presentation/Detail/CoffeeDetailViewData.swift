import BrewDomain
import BrewUI

public struct CoffeeDetailViewData: Sendable, Equatable {
    public let title: String
    public let summary: String
    public let facts: [Fact]
    public let isFavorite: Bool

    public struct Fact: Sendable, Equatable, Identifiable {
        public let label: String
        public let value: String

        public var id: String { label }
    }

    public init(coffee: Coffee, isFavorite: Bool) {
        title = coffee.name
        summary = coffee.summary
        facts = [
            Fact(label: "Origin", value: coffee.origin),
            Fact(label: "Roast", value: coffee.roast.displayName),
            Fact(label: "Tasting notes", value: coffee.notesText),
            Fact(label: "Price", value: coffee.formattedPrice),
        ]
        self.isFavorite = isFavorite
    }

    public var favoriteButtonTitle: String {
        isFavorite ? "Remove from favorites" : "Add to favorites"
    }
}
