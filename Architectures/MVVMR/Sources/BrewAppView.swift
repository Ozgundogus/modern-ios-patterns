#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// The whole Brew app in MVVM-R. Use it as the root of a `WindowGroup`.
public struct BrewAppView: View {
    @State private var catalogRouter = TabRouter()
    @State private var favoritesRouter = TabRouter(popsWhenFavoriteIsRemoved: true)

    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies = .live()) {
        self.dependencies = dependencies
    }

    public var body: some View {
        TabView {
            Tab("Catalog", systemImage: "cup.and.saucer") {
                NavigationStack(path: $catalogRouter.path) {
                    CatalogView(viewModel: CatalogViewModel(dependencies: dependencies, router: catalogRouter))
                        .navigationDestination(for: Route.self) { route in
                            RouteDestination(route: route, router: catalogRouter, dependencies: dependencies)
                        }
                }
            }

            Tab("Favorites", systemImage: "heart") {
                NavigationStack(path: $favoritesRouter.path) {
                    FavoritesView(viewModel: FavoritesViewModel(dependencies: dependencies, router: favoritesRouter))
                        .navigationDestination(for: Route.self) { route in
                            RouteDestination(route: route, router: favoritesRouter, dependencies: dependencies)
                        }
                }
            }
        }
    }
}

#Preview("Brew in MVVM-R") {
    BrewAppView(dependencies: .preview())
}
#endif
