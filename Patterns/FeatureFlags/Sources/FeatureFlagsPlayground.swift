#if canImport(SwiftUI)
import SwiftUI

struct FeatureFlagsPlayground: View {
    @State private var flags = FeatureFlagStore(
        source: StubFlagSource([
            AppFlags.freeShippingThreshold.key: .int(35),
            AppFlags.applePay.key: .rollout(percentage: 50),
        ]),
        userID: "preview-user",
        defaults: UserDefaults(suiteName: "FeatureFlagsPlayground") ?? .standard
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CheckoutEntryView()
                FeatureFlagDebugView()
            }
            .navigationTitle("Feature AppFlags")
        }
        .environment(flags)
        .task { await flags.refresh() }
    }
}

#Preview("Playground") {
    FeatureFlagsPlayground()
}
#endif
