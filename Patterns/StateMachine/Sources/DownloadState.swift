public enum DownloadState: Sendable, Equatable {
    case idle
    case downloading(progress: Double)
    case paused(progress: Double)
    case completed
    case failed(message: String, progress: Double)
}
