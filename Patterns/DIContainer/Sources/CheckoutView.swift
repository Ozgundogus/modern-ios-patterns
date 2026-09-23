#if canImport(SwiftUI)
import SwiftUI

public struct CheckoutView: View {
    @State private var viewModel: CheckoutViewModel

    public init(viewModel: CheckoutViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List {
            Section("Cart") {
                if viewModel.items.isEmpty {
                    Text("Your cart is empty").foregroundStyle(.secondary)
                }
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { _, item in
                    Text(item)
                }
            }
            Section {
                Button("Add coffee") {
                    Task { await viewModel.add("Coffee") }
                }
            }
        }
    }
}

#Preview("Without a container") {
    CheckoutView(viewModel: CheckoutViewModel(cart: CartStore(), logger: ConsoleLogger()))
}
#endif
