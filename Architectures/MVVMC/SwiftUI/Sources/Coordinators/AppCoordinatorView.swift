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
            Tab("Catalog", systemImage: "cup.and.saucer", value: AppCoordinator.Tab.catalog) {
                CatalogCoordinatorView(coordinator: coordinator.catalog)
            }

            Tab("Favorites", systemImage: "heart", value: AppCoordinator.Tab.favorites) {
                FavoritesCoordinatorView(coordinator: coordinator.favorites)
            }
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
