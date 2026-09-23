#if canImport(UIKit)
import BrewData
import UIKit

/// Assembles the module and connects its parts. The only place that knows every concrete type.
enum CatalogModule {
    @MainActor
    static func build(dependencies: BrewDependencies) -> UIViewController {
        let router = DetailRouter(dependencies: dependencies)
        let presenter = CatalogPresenter(interactor: CatalogInteractor(dependencies: dependencies), router: router)
        let view = CatalogViewController(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return view
    }
}
#endif
