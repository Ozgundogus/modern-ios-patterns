#if canImport(SwiftUI)
import BrewData
import BrewDomain
import BrewUI
import SwiftUI

public struct FavoritesView: View {
    @State private var viewModel: FavoritesViewModel

    public init(viewModel: FavoritesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List(viewModel.coffees) { coffee in
            NavigationLink(value: coffee) {
                CoffeeRow(coffee: coffee, isFavorite: true)
            }
        }
        .overlay {
            if viewModel.coffees.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Tap the heart on a coffee to save it here."))
            }
        }
        .task { await viewModel.load() }
        .navigationTitle("Favorites")
        .navigationDestination(for: Coffee.self) { coffee in
            CoffeeDetailView(viewModel: viewModel.makeDetailViewModel(for: coffee))
        }
    }
}

#Preview("Favorites") {
    NavigationStack {
        FavoritesView(viewModel: FavoritesViewModel(dependencies: .preview(favorites: ["huila", "sumatra"])))
    }
}
#endif
