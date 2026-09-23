#if canImport(SwiftUI)
import BrewUI
import ComposableArchitecture
import SwiftUI

struct CatalogView: View {
    @Bindable var store: StoreOf<CatalogFeature>

    var body: some View {
        List {
            Section {
                RoastPicker(roast: $store.roast)
            }
            ForEach(store.coffees) { coffee in
                Button {
                    store.send(.coffeeTapped(coffee))
                } label: {
                    CoffeeRow(coffee: coffee, isFavorite: store.favoriteIDs.contains(coffee.id))
                }
                .foregroundStyle(.primary)
            }
        }
        .overlay {
            if store.coffees.isEmpty && !store.isLoading {
                ContentUnavailableView.search(text: store.query)
            }
        }
        .safeAreaInset(edge: .top) {
            if let message = store.offlineMessage {
                OfflineBanner(message: message)
            }
        }
        .searchable(text: $store.query, prompt: "Name, origin or tasting note")
        .refreshable { await store.send(.refreshPulled).finish() }
        .task { await store.send(.task).finish() }
        .navigationTitle("Catalog")
    }
}
#endif
