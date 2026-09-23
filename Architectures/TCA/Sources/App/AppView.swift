#if canImport(SwiftUI)
import ComposableArchitecture
import SwiftUI

/// The whole Brew app in TCA. Use it as the root of a `WindowGroup`.
public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) { AppFeature() }) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $store.selectedTab) {
            NavigationStack(path: $store.scope(state: \.catalogPath, action: \.catalogPath)) {
                CatalogView(store: store.scope(state: \.catalog, action: \.catalog))
            } destination: { store in
                destination(store)
            }
            .tabItem { Label("Catalog", systemImage: "cup.and.saucer") }
            .tag(AppFeature.Tab.catalog)

            NavigationStack(path: $store.scope(state: \.favoritesPath, action: \.favoritesPath)) {
                FavoritesView(store: store.scope(state: \.favorites, action: \.favorites))
            } destination: { store in
                destination(store)
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
            .tag(AppFeature.Tab.favorites)
        }
    }

    @ViewBuilder
    private func destination(_ store: StoreOf<AppFeature.Path>) -> some View {
        switch store.case {
        case let .detail(store):
            CoffeeDetailView(store: store)
        }
    }
}

#Preview("Brew in TCA") {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    } withDependencies: {
        $0.brew = .from(.preview())
    })
}
#endif
