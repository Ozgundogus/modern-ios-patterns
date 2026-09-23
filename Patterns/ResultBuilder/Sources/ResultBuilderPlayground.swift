#if canImport(SwiftUI)
import SwiftUI

struct ResultBuilderPlayground: View {
    @State private var isNew = true
    @State private var hasBreakingChange = true

    private var note: ReleaseNote {
        ReleaseNote(
            version: "2.0",
            isNew: isNew,
            features: ["Offline mode", "Faster search"],
            breakingChange: hasBreakingChange ? "iOS 17 is now required" : nil,
            docsURL: ReleaseNote.sample.docsURL
        )
    }

    var body: some View {
        Form {
            Section("Inputs") {
                Toggle("New release", isOn: $isNew)
                Toggle("Breaking change", isOn: $hasBreakingChange)
            }
            Section("Output") {
                Text(note.attributedText)
            }
        }
    }
}

#Preview("Release note") {
    ResultBuilderPlayground()
}
#endif
