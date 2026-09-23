public protocol OrderService: Sendable {
    func place(_ order: Order) async throws -> OrderConfirmation
}
