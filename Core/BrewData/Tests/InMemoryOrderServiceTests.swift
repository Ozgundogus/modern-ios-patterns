import BrewDomain
import Testing
@testable import BrewData

struct InMemoryOrderServiceTests {
    @Test func numbersOrdersInSequence() async throws {
        let service = InMemoryOrderService()
        let order = Order(coffee: Coffee.samples[0])

        #expect(try await service.place(order).number == "BR-1001")
        #expect(try await service.place(order).number == "BR-1002")
        #expect(await service.placedOrders.count == 2)
    }

    @Test func failsWhenOffline() async {
        let service = InMemoryOrderService()
        await service.setReachable(false)

        await #expect(throws: OrderError.unavailable) {
            try await service.place(Order(coffee: Coffee.samples[0]))
        }
        #expect(await service.placedOrders.isEmpty)
    }
}
