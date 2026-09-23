#if canImport(SwiftUI)
import SwiftUI

public struct ShopCoordinatorView: View {
    @State private var coordinator: ShopCoordinator

    public init(coordinator: ShopCoordinator = ShopCoordinator()) {
        _coordinator = State(initialValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProductListView(products: coordinator.products) { product in
                coordinator.showProduct(product)
            }
            .navigationDestination(for: ShopCoordinator.Route.self) { route in
                destination(for: route)
            }
        }
        .sheet(item: $coordinator.sheet) { sheet in
            switch sheet {
            case .login:
                LoginView(
                    onLogIn: { coordinator.didLogIn() },
                    onCancel: { coordinator.didCancelLogin() }
                )
            }
        }
        .onOpenURL { url in
            _ = coordinator.handle(url)
        }
    }

    @ViewBuilder
    private func destination(for route: ShopCoordinator.Route) -> some View {
        switch route {
        case .product(let product):
            ProductDetailView(product: product) {
                coordinator.startCheckout(for: product)
            }
        case .checkout(let product):
            CheckoutView(product: product) {
                coordinator.didPlaceOrder(for: product)
            }
        case .confirmation(let product):
            ConfirmationView(product: product) {
                coordinator.finish()
            }
        }
    }
}

#Preview("Logged out") {
    ShopCoordinatorView()
}

#Preview("Logged in") {
    ShopCoordinatorView(coordinator: ShopCoordinator(isLoggedIn: true))
}
#endif
