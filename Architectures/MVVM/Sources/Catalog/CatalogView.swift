#if canImport(SwiftUI)
import BrewData
import BrewDomain
import BrewUI
import SwiftUI

public struct CatalogView: View {
    @State private var viewModel: CatalogViewModel

    public init(viewModel: CatalogViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List {
            Section {
                RoastPicker(roast: $viewModel.roast)
            }
            ForEach(viewModel.coffees) { coffee in
                NavigationLink(value: coffee) {
                    CoffeeRow(coffee: coffee, isFavorite: viewModel.isFavorite(coffee))
                }
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
        .navigationDestination(for: Coffee.self) { coffee in
            CoffeeDetailView(viewModel: viewModel.makeDetailViewModel(for: coffee))
        }
    }
}

#Preview("Catalog") {
    NavigationStack {
        CatalogView(viewModel: CatalogViewModel(dependencies: .preview()))
    }
}
#endif
