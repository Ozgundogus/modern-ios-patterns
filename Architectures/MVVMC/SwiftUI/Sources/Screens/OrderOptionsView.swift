#if canImport(SwiftUI)
import BrewDomain
import BrewUI
import MVVMCViewModels
import SwiftUI

public struct OrderOptionsView: View {
    @Bindable private var viewModel: OrderOptionsViewModel

    public init(viewModel: OrderOptionsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Form {
            Section {
                CoffeeRow(coffee: viewModel.coffee, isFavorite: false)
            }
            Section("Bag") {
                Picker("Size", selection: $viewModel.size) {
                    ForEach(Order.Size.allCases) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                Picker("Grind", selection: $viewModel.grind) {
                    ForEach(Order.Grind.allCases) { grind in
                        Text(grind.displayName).tag(grind)
                    }
                }
                Stepper("Quantity: \(viewModel.quantity)", value: $viewModel.quantity, in: Order.quantityRange)
            }
            Section {
                LabeledContent("Total", value: viewModel.order.formattedTotal)
            }
        }
        .navigationTitle("Order")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { viewModel.cancel() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Review") { viewModel.continueToReview() }
            }
        }
    }
}

#Preview("Order options") {
    NavigationStack {
        OrderOptionsView(viewModel: OrderOptionsViewModel(coffee: Coffee.samples[1]))
    }
}
#endif
