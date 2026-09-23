#if canImport(SwiftUI)
import BrewUI
import SwiftUI

struct CoffeeDetailView: View {
    @State var viewModel: CoffeeDetailViewModel

    var body: some View {
        CoffeeDetailContent(coffee: viewModel.coffee, isFavorite: viewModel.isFavorite) {
            Task { await viewModel.toggleFavorite() }
        }
        .task { await viewModel.load() }
    }
}
#endif
