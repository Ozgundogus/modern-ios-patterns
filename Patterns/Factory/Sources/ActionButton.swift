import Foundation

public struct ActionButton: Sendable, Equatable, Decodable {
    public let title: String
    public let url: URL

    public init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}
