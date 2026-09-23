#if canImport(SwiftUI)
import BrewUI
import ComposableArchitecture
import SwiftUI

struct FavoritesView: View {
    let store: StoreOf<FavoritesFeature>

    var body: some View {
        List(store.coffees) { coffee in
            Button {
                store.send(.coffeeTapped(coffee))
            } label: {
                CoffeeRow(coffee: coffee, isFavorite: true)
            }
            .foregroundStyle(.primary)
        }
        .overlay {
            if store.coffees.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Tap the heart on a coffee to save it here."))
            }
        }
        .task { await store.send(.task).finish() }
        .navigationTitle("Favorites")
    }
}
#endif
