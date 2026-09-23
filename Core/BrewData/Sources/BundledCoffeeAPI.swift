import BrewDomain
import Foundation

/// Serves the catalog from a JSON file in the bundle, with simulated latency and an offline switch.
/// Replace it with a URLSession-based `CoffeeAPI` to talk to a real backend.
public actor BundledCoffeeAPI: CoffeeAPI {
    public private(set) var fetchCount = 0

    private var isReachable = true
    private let latency: Duration

    public init(latency: Duration = .zero) {
        self.latency = latency
    }

    public func setReachable(_ reachable: Bool) {
        isReachable = reachable
    }

    func fetchCoffees() async throws -> [CoffeeDTO] {
        fetchCount += 1
        if latency > .zero {
            try await Task.sleep(for: latency)
        }
        guard isReachable else {
            throw CoffeeError.unavailable
        }
        guard let url = Bundle.module.url(forResource: "coffees", withExtension: "json") else {
            throw CoffeeError.unavailable
        }
        return try JSONDecoder().decode([CoffeeDTO].self, from: Data(contentsOf: url))
    }
}
