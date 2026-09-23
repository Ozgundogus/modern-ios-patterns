#if canImport(UIKit)
import UIKit

@MainActor
public final class UIKitShopCoordinator {
    /// Weak, because the navigation controller owns the coordinator.
    private weak var navigationController: UINavigationController?
    private let products: [Product]
    private var isLoggedIn: Bool

    public init(
        navigationController: UINavigationController,
        products: [Product] = Product.samples,
        isLoggedIn: Bool = false
    ) {
        self.navigationController = navigationController
        self.products = products
        self.isLoggedIn = isLoggedIn
    }

    /// Builds a navigation controller that keeps its coordinator alive.
    /// Use it as `window.rootViewController` in your `SceneDelegate`.
    public static func makeRootViewController() -> UINavigationController {
        let navigationController = CoordinatedNavigationController()
        let coordinator = UIKitShopCoordinator(navigationController: navigationController)
        navigationController.coordinator = coordinator
        coordinator.start()
        return navigationController
    }

    public func start() {
        let list = ProductListViewController(products: products)
        list.onSelect = { [weak self] product in
            self?.showProduct(product)
        }
        navigationController?.setViewControllers([list], animated: false)
    }

    @discardableResult
    public func handle(_ url: URL) -> Bool {
        guard
            let id = DeepLink.productID(from: url),
            let product = products.first(where: { $0.id == id })
        else { return false }

        navigationController?.dismiss(animated: false)
        start()
        showProduct(product, animated: false)
        return true
    }

    private func showProduct(_ product: Product, animated: Bool = true) {
        let detail = ActionViewController(
            title: product.name,
            message: product.formattedPrice,
            buttonTitle: "Buy"
        )
        detail.onAction = { [weak self] in
            self?.startCheckout(for: product)
        }
        navigationController?.pushViewController(detail, animated: animated)
    }

    private func startCheckout(for product: Product) {
        guard isLoggedIn else {
            showLogin { [weak self] in
                self?.startCheckout(for: product)
            }
            return
        }

        let checkout = ActionViewController(
            title: "Checkout",
            message: "Pay \(product.formattedPrice) for \(product.name)?",
            buttonTitle: "Place order"
        )
        checkout.onAction = { [weak self] in
            self?.showConfirmation(for: product)
        }
        navigationController?.pushViewController(checkout, animated: true)
    }

    private func showLogin(then continueFlow: @escaping () -> Void) {
        let login = ActionViewController(
            title: "Log in",
            message: "Log in to continue to checkout.",
            buttonTitle: "Log in"
        )
        login.onAction = { [weak self] in
            guard let self else { return }
            isLoggedIn = true
            navigationController?.dismiss(animated: true)
            continueFlow()
        }
        navigationController?.present(UINavigationController(rootViewController: login), animated: true)
    }

    private func showConfirmation(for product: Product) {
        let confirmation = ActionViewController(
            title: "Order placed",
            message: "Your \(product.name) is on its way.",
            buttonTitle: "Done"
        )
        confirmation.navigationItem.hidesBackButton = true
        confirmation.onAction = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(confirmation, animated: true)
    }
}

#Preview("UIKit coordinator") {
    UIKitShopCoordinator.makeRootViewController()
}
#endif
