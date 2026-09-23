import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class OrderReviewViewModel {
    public let order: Order
    public private(set) var isPlacing = false
    public private(set) var errorMessage: String?

    @ObservationIgnored public var onPlaced: ((OrderConfirmation) -> Void)?

    private let dependencies: BrewDependencies

    public init(order: Order, dependencies: BrewDependencies) {
        self.order = order
        self.dependencies = dependencies
    }

    public func place() async {
        guard !isPlacing else { return }
        isPlacing = true
        defer { isPlacing = false }
        do {
            let confirmation = try await dependencies.placeOrder(order)
            errorMessage = nil
            onPlaced?(confirmation)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
