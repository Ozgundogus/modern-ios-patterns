public struct VendorPayload: Sendable, Equatable, CustomStringConvertible {
    public let name: String
    public let properties: [String: String]

    public var description: String {
        let pairs = properties.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)" }
        return ([name] + pairs).joined(separator: " ")
    }
}
