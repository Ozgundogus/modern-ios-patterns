#if canImport(SwiftUI)
import SwiftUI

public struct FeatureFlagDebugView: View {
    @Environment(FeatureFlagStore.self) private var flags

    public init() {}

    public var body: some View {
        Form {
            Section("Overrides") {
                ForEach(AppFlags.allBool) { flag in
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
#endif
