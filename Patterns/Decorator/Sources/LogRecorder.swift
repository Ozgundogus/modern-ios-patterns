import Observation

@MainActor
@Observable
final class LogRecorder {
    private(set) var lines: [String] = []

    func append(_ line: String) {
        lines.append(line)
    }

    func clear() {
        lines.removeAll()
    }
}
