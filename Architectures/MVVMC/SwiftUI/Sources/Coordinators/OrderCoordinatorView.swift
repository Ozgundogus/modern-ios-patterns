#if canImport(SwiftUI)
import SwiftUI

struct OrderCoordinatorView: View {
    @Bindable var coordinator: OrderCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            OrderOptionsView(viewModel: coordinator.options)
                .navigationDestination(for: OrderCoordinator.Step.self) { step in
                    switch step {
                    case .review(let order):
                        OrderReviewView(viewModel: coordinator.makeReviewViewModel(for: order))
                    case .confirmation(let confirmation):
                        OrderConfirmationView(confirmation: confirmation) { coordinator.finish() }
                    }
                }
        }
    }
}
#endif
