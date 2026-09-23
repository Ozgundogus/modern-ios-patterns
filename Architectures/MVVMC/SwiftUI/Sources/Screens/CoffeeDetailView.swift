#if canImport(SwiftUI)
import BrewUI
import MVVMCViewModels
import SwiftUI

public struct CoffeeDetailView: View {
    @State private var viewModel: CoffeeDetailViewModel

    public init(viewModel: CoffeeDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        CoffeeDetailContent(coffee: viewModel.coffee, isFavorite: viewModel.isFavorite) {
            Task { await viewModel.toggleFavorite() }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.order()
            } label: {
                Label("Order", systemImage: "bag").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
        }
        .task { await viewModel.load() }
    }
}
#endif
