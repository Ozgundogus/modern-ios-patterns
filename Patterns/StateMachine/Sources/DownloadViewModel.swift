import Observation

/// Owns the state and the side effects. The state machine decides *whether* something happens;
/// the view model decides *what to do* when it does (start or stop the transfer).
@MainActor
@Observable
public final class DownloadViewModel {
    public private(set) var state: DownloadState = .idle

    private let chunkDelay: Duration
    private var failAt: Double?
    private var transfer: Task<Void, Never>?

    /// - Parameter failAt: Simulates a dropped connection the first time progress reaches this value.
    public init(chunkDelay: Duration = .milliseconds(250), failAt: Double? = nil) {
        self.chunkDelay = chunkDelay
        self.failAt = failAt
    }

    @discardableResult
    public func send(_ event: DownloadEvent) -> Bool {
        guard let next = state.next(on: event) else { return false }
        state = next

        switch event {
        case .start, .resume, .retry:
            startTransfer()
        case .pause, .cancel:
            transfer?.cancel()
        case .progressed, .finish, .fail:
            break
        }
        return true
    }

    public func waitForTransfer() async {
        await transfer?.value
    }

    private func startTransfer() {
        transfer?.cancel()
        transfer = Task { await runTransfer() }
    }

    private func runTransfer() async {
        while case .downloading(let progress) = state {
            do {
                try await Task.sleep(for: chunkDelay)
            } catch {
                return
            }
            guard case .downloading = state else { return }

            let next = ((progress * 10).rounded() + 1) / 10
            if let failAt, next >= failAt {
                self.failAt = nil
                send(.fail("Connection lost"))
            } else if next >= 1 {
                send(.finish)
            } else {
                send(.progressed(next))
            }
        }
    }
}
