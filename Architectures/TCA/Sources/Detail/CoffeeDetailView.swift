#if canImport(SwiftUI)
import BrewUI
import ComposableArchitecture
import SwiftUI

struct CoffeeDetailView: View {
    let store: StoreOf<CoffeeDetailFeature>

    var body: some View {
        CoffeeDetailContent(coffee: store.coffee, isFavorite: store.isFavorite) {
            store.send(.favoriteTapped)
        }
        .task { await store.send(.task).finish() }
    }
}
#endif
