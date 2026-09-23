#if canImport(SwiftUI)
import SwiftUI

struct CatalogCoordinatorView: View {
    @Bindable var coordinator: CatalogCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CatalogView(viewModel: coordinator.viewModel)
                .navigationDestination(for: CatalogCoordinator.Route.self) { route in
                    switch route {
                    case .detail(let coffee):
                        CoffeeDetailView(viewModel: coordinator.makeDetailViewModel(for: coffee))
                    }
                }
        }
    }
}
#endif
