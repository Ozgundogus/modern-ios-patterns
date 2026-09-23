public struct PostDTO: Sendable, Equatable, Decodable {
    public let id: Int
    public let userID: Int
    public let title: String
    public let body: String

    public init(id: Int, userID: Int, title: String, body: String) {
        self.id = id
        self.userID = userID
        self.title = title
        self.body = body
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case title
        case body
    }
}
