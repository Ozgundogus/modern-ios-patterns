import BrewData
import BrewDomain
import MVVMCViewModels
import Observation

/// A child flow with its own stack: options → review → confirmation.
/// It can be started from any tab and tells its parent when it's done; the parent decides how to close it.
@MainActor
@Observable
public final class OrderCoordinator: Identifiable {
    public enum Step: Hashable {
        case review(Order)
        case confirmation(OrderConfirmation)
    }

    public var path: [Step] = []
    public let options: OrderOptionsViewModel

    @ObservationIgnored var onFinish: (() -> Void)?

    private let dependencies: BrewDependencies

    init(coffee: Coffee, dependencies: BrewDependencies) {
        self.dependencies = dependencies
        options = OrderOptionsViewModel(coffee: coffee)
        options.onContinue = { [weak self] order in self?.path.append(.review(order)) }
        options.onCancel = { [weak self] in self?.finish() }
    }

    func makeReviewViewModel(for order: Order) -> OrderReviewViewModel {
        let review = OrderReviewViewModel(order: order, dependencies: dependencies)
        review.onPlaced = { [weak self] confirmation in self?.path.append(.confirmation(confirmation)) }
        return review
    }

    func finish() {
        onFinish?()
    }
}
