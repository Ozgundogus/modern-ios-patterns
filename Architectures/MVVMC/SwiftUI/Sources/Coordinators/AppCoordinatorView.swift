#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// The whole Brew app in MVVM-C with SwiftUI. Use it as the root of a `WindowGroup`.
public struct AppCoordinatorView: View {
    @State private var coordinator: AppCoordinator

    public init(dependencies: BrewDependencies = .live()) {
        _coordinator = State(initialValue: AppCoordinator(dependencies: dependencies))
    }

    public var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            CatalogCoordinatorView(coordinator: coordinator.catalog)
                .tabItem { Label("Catalog", systemImage: "cup.and.saucer") }
                .tag(AppCoordinator.Tab.catalog)

            FavoritesCoordinatorView(coordinator: coordinator.favorites)
                .tabItem { Label("Favorites", systemImage: "heart") }
                .tag(AppCoordinator.Tab.favorites)
        }
        .sheet(item: $coordinator.order) { order in
            OrderCoordinatorView(coordinator: order)
        }
        .onOpenURL { url in
            Task { await coordinator.open(url) }
        }
    }
}

#Preview("Brew in MVVM-C (SwiftUI)") {
    AppCoordinatorView(dependencies: .preview())
}
#endif
