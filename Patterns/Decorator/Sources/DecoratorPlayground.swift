#if canImport(SwiftUI)
import SwiftUI

struct DecoratorPlayground: View {
    @State private var recorder = LogRecorder()
    @State private var useRetry = true
    @State private var useCache = true
    @State private var stub = StubDataLoader(
        responses: [.failure(URLError(.timedOut)), .success(Data(count: 2_048))],
        latency: .milliseconds(300)
    )
    @State private var loader: any DataLoader = StubDataLoader(responses: [.success(Data())])
    @State private var networkCalls = 0

    private let url = URL(string: "https://example.com/avatar.png")!

    var body: some View {
        Form {
            Section("Decorators") {
                Toggle("Retry up to 3 times", isOn: $useRetry)
                Toggle("Cache in memory", isOn: $useCache)
                Text("Logging is always on").foregroundStyle(.secondary)
            }
            Section {
                Button("Load avatar") { load() }
                Button("Reset") { reset() }
                LabeledContent("Network calls", value: "\(networkCalls)")
            }
            Section("Log") {
                ForEach(Array(recorder.lines.enumerated()), id: \.offset) { _, line in
                    Text(line).font(.caption.monospaced())
                }
            }
        }
        .onAppear { reset() }
        .onChange(of: useRetry) { reset() }
        .onChange(of: useCache) { reset() }
    }

    private func reset() {
        recorder.clear()
        networkCalls = 0
        stub = StubDataLoader(
            responses: [.failure(URLError(.timedOut)), .success(Data(count: 2_048))],
            latency: .milliseconds(300)
        )
        var chain: any DataLoader = stub
        if useRetry { chain = chain.retrying(attempts: 3) }
        if useCache { chain = chain.caching() }
        let recorder = recorder
        loader = chain.logging { line in
            Task { @MainActor in recorder.append(line) }
        }
    }

    private func load() {
        Task {
            _ = try? await loader.data(from: url)
            networkCalls = await stub.callCount
        }
    }
}

#Preview("Stack decorators") {
    DecoratorPlayground()
}
#endif
