import Foundation

public struct Coffee: Sendable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let origin: String
    public let roast: Roast
    public let tastingNotes: [String]
    public let price: Decimal
    public let summary: String

    public init(
        id: String,
        name: String,
        origin: String,
        roast: Roast,
        tastingNotes: [String],
        price: Decimal,
        summary: String
    ) {
        self.id = id
        self.name = name
        self.origin = origin
        self.roast = roast
        self.tastingNotes = tastingNotes
        self.price = price
        self.summary = summary
    }
}
