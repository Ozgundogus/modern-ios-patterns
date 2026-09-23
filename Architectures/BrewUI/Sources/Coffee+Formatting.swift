import BrewDomain
import Foundation

extension Coffee {
    public var formattedPrice: String {
        price.formatted(.currency(code: "USD"))
    }

    public var subtitle: String {
        "\(origin) · \(roast.displayName) roast"
    }

    public var notesText: String {
        tastingNotes.joined(separator: ", ")
    }
}
