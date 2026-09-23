#if canImport(UIKit)
import BrewData
import UIKit

/// The whole Brew app in MVC. Use it as `window.rootViewController`.
public final class BrewTabBarController: UITabBarController {
    public init(dependencies: BrewDependencies = .live()) {
        super.init(nibName: nil, bundle: nil)

        let catalog = UINavigationController(rootViewController: CatalogViewController(dependencies: dependencies))
        catalog.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "cup.and.saucer"), tag: 0)

        let favorites = UINavigationController(rootViewController: FavoritesViewController(dependencies: dependencies))
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)

        viewControllers = [catalog, favorites]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

#Preview("Brew in MVC") {
    BrewTabBarController(dependencies: .preview())
}
#endif
