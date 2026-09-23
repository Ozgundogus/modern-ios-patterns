public struct UserProfile: Sendable, Equatable {
    public let id: String
    public let name: String
    public let email: String

    public init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    public static let ada = UserProfile(id: "user-1", name: "Ada Lovelace", email: "ada@example.com")
}
