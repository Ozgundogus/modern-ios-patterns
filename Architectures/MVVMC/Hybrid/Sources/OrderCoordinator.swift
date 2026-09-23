#if canImport(UIKit)
import BrewData
import BrewDomain
import MVVMCViewModels
import SwiftUI
import UIKit
import protocol MVVMCUIKit.Coordinator
import struct MVVMCSwiftUI.OrderConfirmationView
import struct MVVMCSwiftUI.OrderOptionsView
import struct MVVMCSwiftUI.OrderReviewView

/// A new flow written in SwiftUI from day one. Its steps are SwiftUI views; UIKit still pushes and presents them.
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
        navigationController.setViewControllers([UIHostingController(rootView: OrderOptionsView(viewModel: options))], animated: false)
        navigationController.presentationController?.delegate = self
    }

    func showReview(for order: Order) {
        let review = OrderReviewViewModel(order: order, dependencies: dependencies)
        review.onPlaced = { [weak self] confirmation in self?.showConfirmation(confirmation) }
        navigationController.pushViewController(UIHostingController(rootView: OrderReviewView(viewModel: review)), animated: true)
    }

    func showConfirmation(_ confirmation: OrderConfirmation) {
        let screen = UIHostingController(rootView: OrderConfirmationView(confirmation: confirmation) { [weak self] in self?.finish() })
        screen.navigationItem.hidesBackButton = true
        navigationController.pushViewController(screen, animated: true)
    }

    func finish() {
        onFinish?()
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish()
    }
}
#endif
