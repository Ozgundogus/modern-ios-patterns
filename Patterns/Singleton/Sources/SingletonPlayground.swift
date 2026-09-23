#if canImport(SwiftUI)
import SwiftUI

struct SingletonPlayground: View {
    @State private var settings = SettingsStore(defaults: UserDefaults(suiteName: "SingletonPlayground") ?? .standard)

    var body: some View {
        let reader = ReaderViewModel(settings: settings, wordCount: 1_200)
        Form {
            SettingsView()
            Section("Article") {
                Text("Swift 6 and the end of global mutable state")
                    .font(.system(size: reader.fontSize, weight: .semibold))
                Text("\(reader.minutesToRead) min read").foregroundStyle(.secondary)
            }
        }
        .environment(settings)
    }
}

#Preview("Injected instance, not .shared") {
    SingletonPlayground()
}
#endif
