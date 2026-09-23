#if canImport(SwiftUI)
import BrewUI
import MVVMCViewModels
import SwiftUI

public struct FavoritesView: View {
    private let viewModel: FavoritesViewModel

    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
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
