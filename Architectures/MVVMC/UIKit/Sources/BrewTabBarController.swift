#if canImport(UIKit)
import BrewData
import Foundation
import UIKit

/// The whole Brew app in MVVM-C with UIKit. Use it as `window.rootViewController`.
/// It owns the coordinator tree, and the tree only holds an unowned reference back.
public final class BrewTabBarController: UITabBarController {
    private var coordinator: AppCoordinator?

    public init(dependencies: BrewDependencies = .live()) {
        super.init(nibName: nil, bundle: nil)
        let coordinator = AppCoordinator(tabBarController: self, dependencies: dependencies)
        self.coordinator = coordinator
        coordinator.start()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    /// Forward `scene(_:openURLContexts:)` here.
    @discardableResult
    public func open(_ url: URL) async -> Bool {
        await coordinator?.open(url) ?? false
    }
}

#Preview("Brew in MVVM-C (UIKit)") {
    BrewTabBarController(dependencies: .preview())
}
#endif
