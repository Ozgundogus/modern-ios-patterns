#if canImport(UIKit)
import BrewData
import Foundation
import UIKit

/// Brew halfway through a UIKit → SwiftUI migration. Use it as `window.rootViewController`.
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

    @discardableResult
    public func open(_ url: URL) async -> Bool {
        await coordinator?.open(url) ?? false
    }
}

#Preview("Brew in MVVM-C (Hybrid)") {
    BrewTabBarController(dependencies: .preview())
}
#endif
