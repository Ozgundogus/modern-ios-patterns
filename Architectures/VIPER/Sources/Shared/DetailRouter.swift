#if canImport(UIKit)
import BrewData
import BrewDomain
import UIKit

/// Pushes the detail module. Holds its view controller weakly: the view controller owns the presenter,
/// the presenter owns the router, and the router must not own the view controller back.
final class DetailRouter: DetailRouting {
    weak var viewController: UIViewController?

    private let dependencies: BrewDependencies

    init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    func showDetail(for coffee: Coffee) {
        let detail = DetailModule.build(coffee: coffee, dependencies: dependencies)
        viewController?.navigationController?.pushViewController(detail, animated: true)
    }
}
#endif
