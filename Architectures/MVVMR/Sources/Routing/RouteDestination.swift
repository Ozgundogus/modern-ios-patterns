#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// Builds the screen for a route, wiring it to the router of the tab it's shown in.
struct RouteDestination: View {
    let route: Route
    let router: TabRouter
    let dependencies: BrewDependencies

    var body: some View {
        switch route {
        case .detail(let coffee):
            CoffeeDetailView(viewModel: CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies, router: router))
        }
    }
}
#endif
