import Foundation

public struct TodoItem: Sendable, Equatable, Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var isDone: Bool
    public let createdAt: Date
    /// Used for last-write-wins conflict resolution.
    public var updatedAt: Date

    public init(id: UUID = UUID(), title: String, isDone: Bool = false, createdAt: Date, updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
        self.updatedAt = updatedAt ?? createdAt
    }
}
