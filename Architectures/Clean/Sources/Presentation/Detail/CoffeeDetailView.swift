#if canImport(SwiftUI)
import SwiftUI

struct CoffeeDetailView: View {
    @State var viewModel: CoffeeDetailViewModel

    var body: some View {
        Group {
            if let data = viewModel.viewData {
                Form {
                    Section { Text(data.summary) }
                    Section {
                        ForEach(data.facts) { fact in
                            LabeledContent(fact.label, value: fact.value)
                        }
                    }
                    Section {
                        Button(data.favoriteButtonTitle) {
                            Task { await viewModel.toggleFavorite() }
                        }
                    }
                }
                .navigationTitle(data.title)
            } else if let message = viewModel.errorMessage {
                ContentUnavailableView("Unavailable", systemImage: "exclamationmark.triangle", description: Text(message))
            } else {
                ProgressView()
            }
        }
        .task { await viewModel.load() }
    }
}
#endif
