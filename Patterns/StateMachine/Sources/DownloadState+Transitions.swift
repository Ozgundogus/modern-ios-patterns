extension DownloadState {
    /// Every legal transition in one pure function. `nil` means the event isn't allowed in this state.
    public func next(on event: DownloadEvent) -> DownloadState? {
        switch (self, event) {
        case (.idle, .start):
            .downloading(progress: 0)
        case (.downloading, .progressed(let progress)):
            .downloading(progress: min(max(progress, 0), 1))
        case (.downloading(let progress), .pause):
            .paused(progress: progress)
        case (.paused(let progress), .resume):
            .downloading(progress: progress)
        case (.downloading, .finish):
            .completed
        case (.downloading(let progress), .fail(let message)):
            .failed(message: message, progress: progress)
        case (.failed(_, let progress), .retry):
            .downloading(progress: progress)
        case (.downloading, .cancel), (.paused, .cancel), (.failed, .cancel), (.completed, .cancel):
            .idle
        default:
            nil
        }
    }

    public func accepts(_ event: DownloadEvent) -> Bool {
        next(on: event) != nil
    }
}
