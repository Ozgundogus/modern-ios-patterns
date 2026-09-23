#if canImport(SwiftUI)
import SwiftUI

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel

    var body: some View {
        List(viewModel.rows) { row in
            NavigationLink(value: Route.detail(coffeeID: row.id)) {
                CoffeeRowView(data: row)
            }
        }
        .overlay {
            if viewModel.rows.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Tap the heart on a coffee to save it here."))
            }
        }
        .task { await viewModel.load() }
        .navigationTitle("Favorites")
    }
}
#endif
