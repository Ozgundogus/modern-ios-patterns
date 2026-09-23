public struct KeychainError: Error, Equatable {
    public let status: Int32

    public init(status: Int32) {
        self.status = status
    }
}
