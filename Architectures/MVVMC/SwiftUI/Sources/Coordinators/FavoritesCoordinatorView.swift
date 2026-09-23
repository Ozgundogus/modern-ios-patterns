#if canImport(SwiftUI)
import SwiftUI

struct FavoritesCoordinatorView: View {
    @Bindable var coordinator: FavoritesCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            FavoritesView(viewModel: coordinator.viewModel)
                .navigationDestination(for: FavoritesCoordinator.Route.self) { route in
                    switch route {
                    case .detail(let coffee):
                        CoffeeDetailView(viewModel: coordinator.makeDetailViewModel(for: coffee))
                    }
                }
        }
    }
}
#endif
