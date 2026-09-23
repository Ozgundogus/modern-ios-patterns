import Testing
@testable import Strategy

struct PromoCodeTests {
    @Test(arguments: ["WELCOME10", "welcome10", "  Welcome10 "])
    func codesAreCaseAndWhitespaceInsensitive(code: String) {
        #expect(DiscountStrategy.forPromoCode(code)?.name == "10% off")
    }

    @Test func unknownCodeHasNoStrategy() {
        #expect(DiscountStrategy.forPromoCode("FREE100") == nil)
    }

    @Test func coffeeCodeGivesAFreeEspresso() {
        let strategy = DiscountStrategy.forPromoCode("COFFEE3FOR2")

        #expect(strategy?.discount(for: .sample) == 3)
    }
}
