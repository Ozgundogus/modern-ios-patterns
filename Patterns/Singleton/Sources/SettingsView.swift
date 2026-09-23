#if canImport(SwiftUI)
import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settings

    var body: some View {
        Section("Settings") {
            Toggle("Large text", isOn: Binding(
                get: { settings.prefersLargeText },
                set: { settings.setPrefersLargeText($0) }
            ))
            LabeledContent("Reading speed ×\(settings.readingSpeed, specifier: "%.1f")") {
                Slider(value: Binding(
                    get: { settings.readingSpeed },
                    set: { settings.setReadingSpeed($0) }
                ), in: 0.5...2, step: 0.25)
            }
            Button("Reset", role: .destructive) { settings.reset() }
        }
    }
}
#endif
