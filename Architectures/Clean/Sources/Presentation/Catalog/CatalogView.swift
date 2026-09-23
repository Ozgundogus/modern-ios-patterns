#if canImport(SwiftUI)
import BrewUI
import SwiftUI

struct CatalogView: View {
    @State var viewModel: CatalogViewModel

    var body: some View {
        List {
            Section {
                RoastPicker(roast: $viewModel.roast)
            }
            ForEach(viewModel.rows) { row in
                NavigationLink(value: Route.detail(coffeeID: row.id)) {
                    CoffeeRowView(data: row)
                }
            }
        }
        .overlay {
            if viewModel.rows.isEmpty && !viewModel.isLoading {
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
