import Testing
@testable import BrewDomain

struct PlaceOrderUseCaseTests {
    @Test func placesAValidOrder() async throws {
        let service = SpyOrderService()
        let placeOrder = PlaceOrderUseCase(service: service)
        let order = Order(coffee: Coffee.samples[0], quantity: 2)

        let confirmation = try await placeOrder(order)

        #expect(confirmation.order == order)
        #expect(await service.placedOrders == [order])
    }

    @Test func rejectsAQuantityOutsideTheRangeWithoutCallingTheService() async {
        let service = SpyOrderService()
        let placeOrder = PlaceOrderUseCase(service: service)

        await #expect(throws: OrderError.invalidQuantity) {
            try await placeOrder(Order(coffee: Coffee.samples[0], quantity: 0))
        }
        #expect(await service.placedOrders.isEmpty)
    }
}
