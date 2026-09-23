#if canImport(SwiftUI)
import SwiftUI

struct StateMachinePlayground: View {
    @State private var download = DownloadViewModel(failAt: 0.6)

    private let actions: [(title: String, event: DownloadEvent)] = [
        ("Start", .start), ("Pause", .pause), ("Resume", .resume), ("Retry", .retry), ("Cancel", .cancel),
    ]

    var body: some View {
        Form {
            Section("State") {
                Text(String(describing: download.state)).font(.body.monospaced())
                ProgressView(value: progress)
            }
            Section("Events") {
                ForEach(actions, id: \.title) { action in
                    Button(action.title) { download.send(action.event) }
                        .disabled(!download.state.accepts(action.event))
                }
            }
        }
    }

    private var progress: Double {
        switch download.state {
        case .idle: 0
        case .downloading(let progress), .paused(let progress), .failed(_, let progress): progress
        case .completed: 1
        }
    }
}

#Preview("Download") {
    StateMachinePlayground()
}
#endif
