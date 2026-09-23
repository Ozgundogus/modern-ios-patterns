/// The Composition Root, backed by a container.
extension Container {
    public static func live() -> Container {
        let container = Container()

        container.register((any AppLogger).self, scope: .singleton) { _ in
            ConsoleLogger()
        }

        container.register((any HTTPClient).self, scope: .singleton) { container in
            try URLSessionHTTPClient(logger: container.resolve())
        }

        return container
    }

    /// A feature scope: every checkout flow gets its own `CartStore`,
    /// while app-wide singletons like `AppLogger` are shared with the parent.
    public func makeCheckoutScope() -> Container {
        let scope = makeChild()
        scope.register(CartStore.self, scope: .singleton) { _ in
            CartStore()
        }
        return scope
    }

    @MainActor
    public func makeCheckoutViewModel() throws -> CheckoutViewModel {
        try CheckoutViewModel(cart: resolve(), logger: resolve())
    }
}
