import BrewDomain

/// Places orders in memory with simulated latency and an offline switch.
/// Replace it with a URLSession-based `OrderService` to talk to a real backend.
public actor InMemoryOrderService: OrderService {
    public private(set) var placedOrders: [Order] = []

    private var isReachable = true
    private let latency: Duration

    public init(latency: Duration = .zero) {
        self.latency = latency
    }

    public func setReachable(_ reachable: Bool) {
        isReachable = reachable
    }

    public func place(_ order: Order) async throws -> OrderConfirmation {
        if latency > .zero {
            try await Task.sleep(for: latency)
        }
        guard isReachable else {
            throw OrderError.unavailable
        }
        placedOrders.append(order)
        return OrderConfirmation(number: "BR-\(1000 + placedOrders.count)", order: order)
    }
}
