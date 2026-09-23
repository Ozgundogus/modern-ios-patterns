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

public struct CheckoutFlow: View {
    private let viewModel: CheckoutViewModel?
    private let error: String?

    @MainActor
    public init(container: Container) {
        do {
            viewModel = try container.makeCheckoutScope().makeCheckoutViewModel()
            error = nil
        } catch {
            viewModel = nil
            self.error = String(describing: error)
        }
    }

    public var body: some View {
        if let viewModel {
            CheckoutView(viewModel: viewModel)
        } else {
            ContentUnavailableView(
                "Missing dependency",
                systemImage: "exclamationmark.triangle",
                description: Text(error ?? "")
            )
        }
    }
}

#Preview("From the container") {
    CheckoutFlow(container: .live())
}

#Preview("Without a container") {
    CheckoutView(viewModel: CheckoutViewModel(cart: CartStore(), logger: ConsoleLogger()))
}

#Preview("Missing registration") {
    CheckoutFlow(container: Container())
}
#endif
