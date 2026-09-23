#if canImport(SwiftUI)
import BrewData
import BrewDomain
import BrewUI
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
        .task { await viewModel.load() }
    }
}

#Preview("Detail") {
    NavigationStack {
        CoffeeDetailView(viewModel: CoffeeDetailViewModel(coffee: Coffee.samples[1], dependencies: .preview()))
    }
}
#endif
