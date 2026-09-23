#if canImport(UIKit)
import BrewData
import BrewDomain
import UIKit

enum DetailModule {
    @MainActor
    static func build(coffee: Coffee, dependencies: BrewDependencies) -> UIViewController {
        let presenter = DetailPresenter(coffee: coffee, interactor: DetailInteractor(dependencies: dependencies))
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
#endif
