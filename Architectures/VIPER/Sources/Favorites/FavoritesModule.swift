#if canImport(UIKit)
import BrewData
import UIKit

enum FavoritesModule {
    @MainActor
    static func build(dependencies: BrewDependencies) -> UIViewController {
        let router = DetailRouter(dependencies: dependencies)
        let presenter = FavoritesPresenter(interactor: FavoritesInteractor(dependencies: dependencies), router: router)
        let view = FavoritesViewController(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return view
    }
}
#endif
