#if canImport(UIKit)
import BrewData
import BrewDomain
import MVVMCViewModels
import UIKit

/// A child flow in its own navigation controller: options → review → confirmation.
/// It fills its stack; the parent presents and dismisses it and removes it from the tree.
@MainActor
public final class OrderCoordinator: NSObject, Coordinator, UIAdaptivePresentationControllerDelegate {
    public var childCoordinators: [any Coordinator] = []
    public let navigationController = UINavigationController()

    var onFinish: (() -> Void)?

    private let coffee: Coffee
    private let dependencies: BrewDependencies

    init(coffee: Coffee, dependencies: BrewDependencies) {
        self.coffee = coffee
        self.dependencies = dependencies
        super.init()
    }

    public func start() {
        let options = OrderOptionsViewModel(coffee: coffee)
        options.onContinue = { [weak self] order in self?.showReview(for: order) }
        options.onCancel = { [weak self] in self?.finish() }
        navigationController.setViewControllers([OrderOptionsViewController(viewModel: options)], animated: false)
        navigationController.presentationController?.delegate = self
    }

    func showReview(for order: Order) {
        let review = OrderReviewViewModel(order: order, dependencies: dependencies)
        review.onPlaced = { [weak self] confirmation in self?.showConfirmation(confirmation) }
        navigationController.pushViewController(OrderReviewViewController(viewModel: review), animated: true)
    }

    func showConfirmation(_ confirmation: OrderConfirmation) {
        let screen = OrderConfirmationViewController(confirmation: confirmation) { [weak self] in self?.finish() }
        navigationController.pushViewController(screen, animated: true)
    }

    func finish() {
        onFinish?()
    }

    /// A swipe down closes the sheet without any button, so without this the parent would never remove the child.
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish()
    }
}
#endif
