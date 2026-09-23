import Testing
@testable import StateMachine

struct DownloadStateTests {
    @Test(arguments: [
        (DownloadState.idle, DownloadEvent.start, DownloadState.downloading(progress: 0)),
        (.downloading(progress: 0.2), .progressed(0.5), .downloading(progress: 0.5)),
        (.downloading(progress: 0.5), .pause, .paused(progress: 0.5)),
        (.paused(progress: 0.5), .resume, .downloading(progress: 0.5)),
        (.downloading(progress: 0.9), .finish, .completed),
        (.downloading(progress: 0.4), .fail("Offline"), .failed(message: "Offline", progress: 0.4)),
        (.failed(message: "Offline", progress: 0.4), .retry, .downloading(progress: 0.4)),
        (.paused(progress: 0.5), .cancel, .idle),
        (.completed, .cancel, .idle),
    ])
    func allowedTransitions(from state: DownloadState, on event: DownloadEvent, to expected: DownloadState) {
        #expect(state.next(on: event) == expected)
    }

    @Test(arguments: [
        (DownloadState.idle, DownloadEvent.pause),
        (.idle, .finish),
        (.downloading(progress: 0.5), .start),
        (.paused(progress: 0.5), .progressed(0.6)),
        (.paused(progress: 0.5), .finish),
        (.completed, .start),
        (.completed, .retry),
        (.failed(message: "Offline", progress: 0), .resume),
    ])
    func rejectedEvents(in state: DownloadState, event: DownloadEvent) {
        #expect(state.next(on: event) == nil)
        #expect(!state.accepts(event))
    }

    @Test func progressIsClamped() {
        #expect(DownloadState.downloading(progress: 0).next(on: .progressed(1.5)) == .downloading(progress: 1))
        #expect(DownloadState.downloading(progress: 0).next(on: .progressed(-1)) == .downloading(progress: 0))
    }
}
