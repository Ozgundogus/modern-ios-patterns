#if canImport(SwiftUI)
import SwiftUI

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

#Preview("Missing registration") {
    CheckoutFlow(container: Container())
}
#endif
