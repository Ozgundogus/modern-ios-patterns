public struct ConsoleLogger: AppLogger {
    public init() {}

    public func log(_ message: String) {
        print("[app] \(message)")
    }
}
