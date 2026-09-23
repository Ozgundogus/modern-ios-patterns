#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// The whole Brew app in Clean Architecture. Use it as the root of a `WindowGroup`.
public struct BrewAppView: View {
    private let factory: SceneFactory

    public init(dependencies: BrewDependencies = .live()) {
        factory = SceneFactory(dependencies: dependencies)
    }

    public var body: some View {
        TabView {
            NavigationStack {
                CatalogView(viewModel: factory.makeCatalogViewModel())
                    .navigationDestination(for: Route.self) { route in destination(for: route) }
            }
            .tabItem { Label("Catalog", systemImage: "cup.and.saucer") }

            NavigationStack {
                FavoritesView(viewModel: factory.makeFavoritesViewModel())
                    .navigationDestination(for: Route.self) { route in destination(for: route) }
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .detail(let coffeeID):
            CoffeeDetailView(viewModel: factory.makeDetailViewModel(coffeeID: coffeeID))
        }
    }
}

#Preview("Brew in Clean Architecture") {
    BrewAppView(dependencies: .preview())
}
#endif
