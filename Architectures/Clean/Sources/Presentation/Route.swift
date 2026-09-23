/// Routes carry IDs, not entities, so a screen always loads fresh data through its own use case.
public enum Route: Hashable, Sendable {
    case detail(coffeeID: String)
}
