#if canImport(UIKit)
import BrewData
import UIKit

/// The whole Brew app in VIPER. Use it as `window.rootViewController`.
public final class BrewTabBarController: UITabBarController {
    public init(dependencies: BrewDependencies = .live()) {
        super.init(nibName: nil, bundle: nil)

        let catalog = UINavigationController(rootViewController: CatalogModule.build(dependencies: dependencies))
        catalog.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "cup.and.saucer"), tag: 0)

        let favorites = UINavigationController(rootViewController: FavoritesModule.build(dependencies: dependencies))
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)

        viewControllers = [catalog, favorites]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

#Preview("Brew in VIPER") {
    BrewTabBarController(dependencies: .preview())
}
#endif
