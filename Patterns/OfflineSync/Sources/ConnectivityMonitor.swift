public protocol ConnectivityMonitor: Sendable {
    /// Emits `true` when the device is online, `false` when it goes offline.
    func updates() -> AsyncStream<Bool>
}
