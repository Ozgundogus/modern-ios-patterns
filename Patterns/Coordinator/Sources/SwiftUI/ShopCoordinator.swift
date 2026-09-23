import Foundation
import Observation

@MainActor
@Observable
public final class ShopCoordinator {
    public enum Route: Hashable, Sendable {
        case product(Product)
        case checkout(Product)
        case confirmation(Product)
    }

    public enum Sheet: String, Identifiable, Sendable {
        case login
        public var id: String { rawValue }
    }

    public var path: [Route] = []
    public var sheet: Sheet?
    public private(set) var isLoggedIn: Bool
    public let products: [Product]

    private var pendingRoute: Route?

    public init(products: [Product] = Product.samples, isLoggedIn: Bool = false) {
        self.products = products
        self.isLoggedIn = isLoggedIn
    }

    public func showProduct(_ product: Product) {
        path.append(.product(product))
    }

    public func startCheckout(for product: Product) {
        let route = Route.checkout(product)
        guard isLoggedIn else {
            pendingRoute = route
            sheet = .login
            return
        }
        path.append(route)
    }

    public func didLogIn() {
        isLoggedIn = true
        sheet = nil
        if let pendingRoute {
            self.pendingRoute = nil
            path.append(pendingRoute)
        }
    }

    public func didCancelLogin() {
        pendingRoute = nil
        sheet = nil
    }

    public func didPlaceOrder(for product: Product) {
        path.append(.confirmation(product))
    }

    public func finish() {
        path.removeAll()
    }

    @discardableResult
    public func handle(_ url: URL) -> Bool {
        guard
            let id = DeepLink.productID(from: url),
            let product = products.first(where: { $0.id == id })
        else { return false }

        sheet = nil
        pendingRoute = nil
        path = [.product(product)]
        return true
    }
}
