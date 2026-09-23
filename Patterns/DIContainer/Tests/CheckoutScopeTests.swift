import Testing
@testable import DIContainer

@MainActor
struct CheckoutScopeTests {
    @Test func eachCheckoutFlowGetsItsOwnCart() async throws {
        let app = Container.live()

        let firstFlow = try app.makeCheckoutScope().makeCheckoutViewModel()
        let secondFlow = try app.makeCheckoutScope().makeCheckoutViewModel()
        await firstFlow.add("Coffee")

        #expect(firstFlow.items == ["Coffee"])
        #expect(secondFlow.items.isEmpty)
    }
}
