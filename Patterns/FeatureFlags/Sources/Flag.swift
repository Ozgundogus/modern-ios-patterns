public struct Flag<Value: FlagValueType>: Sendable, Identifiable {
    public let key: String
    public let defaultValue: Value
    public let summary: String

    public var id: String { key }

    public init(_ key: String, default defaultValue: Value, summary: String) {
        self.key = key
        self.defaultValue = defaultValue
        self.summary = summary
    }
}
