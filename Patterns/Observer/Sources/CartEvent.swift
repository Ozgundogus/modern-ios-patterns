public enum CartEvent: Sendable, Equatable {
    case itemAdded(String)
    case itemRemoved(String)
    case cleared
}
