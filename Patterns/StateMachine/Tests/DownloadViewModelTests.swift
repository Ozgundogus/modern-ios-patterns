import Testing
@testable import StateMachine

@MainActor
struct DownloadViewModelTests {
    @Test func downloadRunsToCompletion() async {
        let download = DownloadViewModel(chunkDelay: .zero)

        download.send(.start)
        await download.waitForTransfer()

        #expect(download.state == .completed)
    }

    @Test func failureThenRetryCompletes() async {
        let download = DownloadViewModel(chunkDelay: .zero, failAt: 0.5)

        download.send(.start)
        await download.waitForTransfer()
        #expect(download.state == .failed(message: "Connection lost", progress: 0.4))

        download.send(.retry)
        await download.waitForTransfer()
        #expect(download.state == .completed)
    }

    @Test func pauseStopsTheTransfer() async {
        let download = DownloadViewModel(chunkDelay: .zero)

        download.send(.start)
        download.send(.pause)
        await download.waitForTransfer()

        #expect(download.state == .paused(progress: 0))
    }

    @Test func invalidEventsAreIgnored() {
        let download = DownloadViewModel(chunkDelay: .zero)

        #expect(!download.send(.finish))
        #expect(download.state == .idle)
    }
}
