import Foundation
import Testing
import BrewDomain
@testable import BrewData

struct CoffeeDTOMappingTests {
    @Test func mapsEveryField() throws {
        let coffee = try #require(CoffeeDTO.huila.toDomain())

        #expect(coffee.id == "huila")
        #expect(coffee.roast == .medium)
        #expect(coffee.price == Decimal(string: "14.50", locale: Locale(identifier: "en_US_POSIX")))
        #expect(coffee.tastingNotes == ["Caramel"])
    }

    @Test func dropsUnknownRoasts() {
        #expect(CoffeeDTO.huila.with(roast: "cinnamon").toDomain() == nil)
    }

    @Test func dropsMalformedPrices() {
        #expect(CoffeeDTO.huila.with(priceUSD: "free").toDomain() == nil)
    }

    @Test func decodesSnakeCaseJSON() throws {
        let json = Data("""
        [{"id": "huila", "name": "Huila", "origin": "Colombia", "roast": "medium",
          "tasting_notes": ["Caramel"], "price_usd": "14.50", "summary": "Sweet and balanced."}]
        """.utf8)

        #expect(try JSONDecoder().decode([CoffeeDTO].self, from: json) == [.huila])
    }
}
