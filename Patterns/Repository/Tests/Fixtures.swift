@testable import Repository

extension PostDTO {
    static let fixture = PostDTO(id: 1, userID: 7, title: "hello world", body: "line one\nline two")
}

extension Article {
    static let fixture = Article(id: 1, title: "Hello World", summary: "line one line two")
}
