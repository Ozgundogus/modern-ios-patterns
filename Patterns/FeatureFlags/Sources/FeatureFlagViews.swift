#if canImport(SwiftUI)
import SwiftUI

public struct CheckoutEntryView: View {
    @Environment(FeatureFlagStore.self) private var flags

    public init() {}

    public var body: some View {
        List {
            Section {
                Text(flags[Flags.welcomeMessage]).font(.headline)
                Text("Free shipping over $\(flags[Flags.freeShippingThreshold])")
                    .foregroundStyle(.secondary)
            }
            Section {
                if flags[Flags.newCheckout] {
                    Label("One-page checkout", systemImage: "bolt.fill")
                } else {
                    Label("Classic checkout (3 steps)", systemImage: "list.number")
                }
                if flags[Flags.applePay] {
                    Label("Pay with Apple Pay", systemImage: "apple.logo")
                }
            }
        }
    }
}

public struct FeatureFlagDebugView: View {
    @Environment(FeatureFlagStore.self) private var flags

    public init() {}

    public var body: some View {
        Form {
            Section("Overrides") {
                ForEach(Flags.allBool) { flag in
                    Toggle(isOn: binding(for: flag)) {
                        VStack(alignment: .leading) {
                            Text(flag.key).font(.body.monospaced())
                            Text(flag.summary).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .tint(flags.isOverridden(flag) ? .orange : nil)
                }
            }
            Section {
                Button("Reset all overrides", role: .destructive) {
                    flags.resetOverrides()
                }
            }
        }
    }

    private func binding(for flag: Flag<Bool>) -> Binding<Bool> {
        Binding(
            get: { flags[flag] },
            set: { flags.setOverride($0, for: flag) }
        )
    }
}

struct FeatureFlagPlayground: View {
    @State private var flags = FeatureFlagStore(
        source: StaticFlagSource([
            Flags.freeShippingThreshold.key: .int(35),
            Flags.applePay.key: .rollout(percentage: 50),
        ]),
        userID: "preview-user",
        defaults: UserDefaults(suiteName: "FeatureFlagPlayground") ?? .standard
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CheckoutEntryView()
                FeatureFlagDebugView()
            }
            .navigationTitle("Feature Flags")
        }
        .environment(flags)
        .task { await flags.refresh() }
    }
}

#Preview("Playground") {
    FeatureFlagPlayground()
}
#endif
