public struct PlaceOrderUseCase: Sendable {
    private let service: any OrderService

    public init(service: any OrderService) {
        self.service = service
    }

    public func callAsFunction(_ order: Order) async throws -> OrderConfirmation {
        guard Order.quantityRange.contains(order.quantity) else {
            throw OrderError.invalidQuantity
        }
        return try await service.place(order)
    }
}
