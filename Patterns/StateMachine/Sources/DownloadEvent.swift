public enum DownloadEvent: Sendable, Equatable {
    case start
    case progressed(Double)
    case pause
    case resume
    case finish
    case fail(String)
    case retry
    case cancel
}
