#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// The whole Brew app in MVVM-C. Use it as the root of a `WindowGroup`.
public struct AppCoordinatorView: View {
    @State private var coordinator: AppCoordinator

    public init(dependencies: BrewDependencies = .live()) {
        _coordinator = State(initialValue: AppCoordinator(dependencies: dependencies))
    }

    public var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.catalogPath) {
                CatalogView(viewModel: coordinator.catalog)
                    .navigationDestination(for: AppCoordinator.Route.self) { route in destination(for: route) }
            }
            .tabItem { Label("Catalog", systemImage: "cup.and.saucer") }
            .tag(AppCoordinator.Tab.catalog)

            NavigationStack(path: $coordinator.favoritesPath) {
                FavoritesView(viewModel: coordinator.favorites)
                    .navigationDestination(for: AppCoordinator.Route.self) { route in destination(for: route) }
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
            .tag(AppCoordinator.Tab.favorites)
        }
        .onOpenURL { url in
            Task { await coordinator.open(url) }
        }
    }

    @ViewBuilder
    private func destination(for route: AppCoordinator.Route) -> some View {
        switch route {
        case .detail(let coffee):
            CoffeeDetailView(viewModel: coordinator.makeDetailViewModel(for: coffee))
        }
    }
}

#Preview("Brew in MVVM-C") {
    AppCoordinatorView(dependencies: .preview())
}
#endif
