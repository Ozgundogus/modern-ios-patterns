#if canImport(SwiftUI)
import BrewDomain
import BrewUI
import SwiftUI

struct CatalogView: View {
    @State var viewModel: CatalogViewModel

    var body: some View {
        List {
            Section {
                RoastPicker(roast: $viewModel.roast)
            }
            ForEach(viewModel.coffees) { coffee in
                Button {
                    viewModel.select(coffee)
                } label: {
                    CoffeeRow(coffee: coffee, isFavorite: viewModel.isFavorite(coffee))
                }
                .foregroundStyle(.primary)
            }
        }
        .overlay {
            if viewModel.coffees.isEmpty && !viewModel.isLoading {
                ContentUnavailableView.search(text: viewModel.query)
            }
        }
        .safeAreaInset(edge: .top) {
            if let message = viewModel.offlineMessage {
                OfflineBanner(message: message)
            }
        }
        .searchable(text: $viewModel.query, prompt: "Name, origin or tasting note")
        .refreshable { await viewModel.refresh() }
        .task(id: viewModel.searchKey) { await viewModel.load() }
        .navigationTitle("Catalog")
    }
}
#endif
