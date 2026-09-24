#if canImport(SwiftUI)
import BrewData
import SwiftUI

/// The whole Brew app in MVVM. Use it as the root of a `WindowGroup`.
public struct BrewAppView: View {
    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies = .live()) {
        self.dependencies = dependencies
    }

    public var body: some View {
        TabView {
            Tab("Catalog", systemImage: "cup.and.saucer") {
                NavigationStack {
                    CatalogView(viewModel: CatalogViewModel(dependencies: dependencies))
                }
            }

            Tab("Favorites", systemImage: "heart") {
                NavigationStack {
                    FavoritesView(viewModel: FavoritesViewModel(dependencies: dependencies))
                }
            }
        }
    }
}

#Preview("Brew in MVVM") {
    BrewAppView(dependencies: .preview())
}
#endif
