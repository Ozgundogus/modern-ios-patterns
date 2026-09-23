#if canImport(SwiftUI)
import BrewUI
import SwiftUI

struct FavoritesView: View {
    let viewModel: FavoritesViewModel

    var body: some View {
        List(viewModel.coffees) { coffee in
            Button {
                viewModel.select(coffee)
            } label: {
                CoffeeRow(coffee: coffee, isFavorite: true)
            }
            .foregroundStyle(.primary)
        }
        .overlay {
            if viewModel.coffees.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Tap the heart on a coffee to save it here."))
            }
        }
        .task { await viewModel.load() }
        .navigationTitle("Favorites")
    }
}
#endif
