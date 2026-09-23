@testable import BrewDomain

actor SpyOrderService: OrderService {
    private(set) var placedOrders: [Order] = []

    func place(_ order: Order) -> OrderConfirmation {
        placedOrders.append(order)
        return OrderConfirmation(number: "BR-TEST", order: order)
    }
}
