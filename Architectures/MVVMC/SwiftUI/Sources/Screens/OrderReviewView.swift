#if canImport(SwiftUI)
import BrewUI
import MVVMCViewModels
import SwiftUI

public struct OrderReviewView: View {
    @State private var viewModel: OrderReviewViewModel

    public init(viewModel: OrderReviewViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        Form {
            Section {
                LabeledContent("Coffee", value: viewModel.order.coffee.name)
                LabeledContent("Bag", value: viewModel.order.summary)
                LabeledContent("Total", value: viewModel.order.formattedTotal)
            }
            if let message = viewModel.errorMessage {
                Section {
                    Label(message, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
            }
            Section {
                Button {
                    Task { await viewModel.place() }
                } label: {
                    if viewModel.isPlacing {
                        ProgressView()
                    } else {
                        Text("Place order")
                    }
                }
                .disabled(viewModel.isPlacing)
            }
        }
        .navigationTitle("Review")
    }
}
#endif
