import Testing
@testable import BrewDomain

struct CoffeeSearchTests {
    let huila = Coffee.samples[1]

    @Test(arguments: ["", "  ", "huila", "HUILA", "colombia", "caramel", "Cocoa"])
    func matchingQueries(query: String) {
        #expect(huila.matches(query))
    }

    @Test(arguments: ["ethiopia", "jasmine", "xyz"])
    func nonMatchingQueries(query: String) {
        #expect(!huila.matches(query))
    }

    @Test func ignoresDiacritics() {
        let cafe = Coffee(id: "c", name: "Café Brûlé", origin: "France", roast: .dark, tastingNotes: [], price: 1, summary: "")

        #expect(cafe.matches("cafe brule"))
    }
}
