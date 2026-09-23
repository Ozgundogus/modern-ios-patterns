import BrewDomain
import BrewUI

public struct DetailDisplayModel: Sendable, Equatable {
    public let title: String
    public let summary: String
    public let facts: String
    public let favoriteButtonTitle: String

    public init(coffee: Coffee, isFavorite: Bool) {
        title = coffee.name
        summary = coffee.summary
        facts = """
        Origin: \(coffee.origin)
        Roast: \(coffee.roast.displayName)
        Tasting notes: \(coffee.notesText)
        Price: \(coffee.formattedPrice)
        """
        favoriteButtonTitle = isFavorite ? "Remove from favorites" : "Add to favorites"
    }
}
