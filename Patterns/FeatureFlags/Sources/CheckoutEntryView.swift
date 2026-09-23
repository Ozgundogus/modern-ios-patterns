#if canImport(SwiftUI)
import SwiftUI

public struct CheckoutEntryView: View {
    @Environment(FeatureFlagStore.self) private var flags

    public init() {}

    public var body: some View {
        List {
            Section {
                Text(flags[AppFlags.welcomeMessage]).font(.headline)
                Text("Free shipping over $\(flags[AppFlags.freeShippingThreshold])")
                    .foregroundStyle(.secondary)
            }
            Section {
                if flags[AppFlags.newCheckout] {
                    Label("One-page checkout", systemImage: "bolt.fill")
                } else {
                    Label("Classic checkout (3 steps)", systemImage: "list.number")
                }
                if flags[AppFlags.applePay] {
                    Label("Pay with Apple Pay", systemImage: "apple.logo")
                }
            }
        }
    }
}
#endif
