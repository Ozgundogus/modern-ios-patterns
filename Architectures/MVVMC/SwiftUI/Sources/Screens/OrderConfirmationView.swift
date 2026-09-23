#if canImport(SwiftUI)
import BrewDomain
import BrewUI
import SwiftUI

/// Shows a finished order. It has no logic of its own, so it gets a value and a closure instead of a view model.
public struct OrderConfirmationView: View {
    private let confirmation: OrderConfirmation
    private let onDone: () -> Void

    public init(confirmation: OrderConfirmation, onDone: @escaping () -> Void) {
        self.confirmation = confirmation
        self.onDone = onDone
    }

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text("Order \(confirmation.number) placed")
                .font(.title2.bold())
            Text("\(confirmation.order.coffee.name), \(confirmation.order.summary) · \(confirmation.order.formattedTotal)")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}
#endif
