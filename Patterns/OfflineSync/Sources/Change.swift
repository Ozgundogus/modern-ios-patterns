import Foundation

/// A change the user made locally that the server hasn't seen yet.
public enum Change: Sendable, Equatable, Codable {
    case upsert(TodoItem)
    case delete(id: UUID, at: Date)

    public var itemID: UUID {
        switch self {
        case .upsert(let item): item.id
        case .delete(let id, _): id
        }
    }
}
