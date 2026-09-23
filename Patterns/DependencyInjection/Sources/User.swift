public struct User: Sendable, Equatable, Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let email: String

    public init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    public static let sample = User(id: 1, name: "Ada Lovelace", email: "ada@example.com")
}
