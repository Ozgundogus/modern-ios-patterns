struct CoffeeDTO: Sendable, Equatable, Codable {
    let id: String
    let name: String
    let origin: String
    let roast: String
    let tastingNotes: [String]
    let priceUSD: String
    let summary: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case roast
        case tastingNotes = "tasting_notes"
        case priceUSD = "price_usd"
        case summary
    }
}
