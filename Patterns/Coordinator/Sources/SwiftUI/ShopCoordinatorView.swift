#if canImport(SwiftUI)
import SwiftUI

/// Connects the coordinator to SwiftUI: the stack, the sheet and deep links.
/// Screens get closures, so none of them knows what comes next.
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

// MARK: - Screens: no navigation logic inside

struct ProductListView: View {
    let products: [Product]
    let onSelect: (Product) -> Void

    var body: some View {
        List(products) { product in
            Button {
                onSelect(product)
            } label: {
                LabeledContent(product.name, value: product.formattedPrice)
            }
        }
        .navigationTitle("Shop")
    }
}

struct ProductDetailView: View {
    let product: Product
    let onBuy: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(product.name).font(.largeTitle)
            Text(product.formattedPrice).foregroundStyle(.secondary)
            Button("Buy", action: onBuy).buttonStyle(.borderedProminent)
        }
        .navigationTitle(product.name)
    }
}

struct CheckoutView: View {
    let product: Product
    let onPlaceOrder: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Pay \(product.formattedPrice) for \(product.name)?")
            Button("Place order", action: onPlaceOrder).buttonStyle(.borderedProminent)
        }
        .navigationTitle("Checkout")
    }
}

struct ConfirmationView: View {
    let product: Product
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 64)).foregroundStyle(.green)
            Text("Your \(product.name) is on its way.")
            Button("Done", action: onDone).buttonStyle(.borderedProminent)
        }
        .navigationTitle("Order placed")
        .navigationBarBackButtonHidden()
    }
}

struct LoginView: View {
    let onLogIn: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Log in to continue to checkout.")
                Button("Log in", action: onLogIn).buttonStyle(.borderedProminent)
            }
            .navigationTitle("Log in")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
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
