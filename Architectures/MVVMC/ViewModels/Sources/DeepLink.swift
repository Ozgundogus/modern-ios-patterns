import BrewDomain
import Foundation

/// The URLs Brew opens: `brew://coffee/<id>` and `brew://coffee/<id>/order`.
public enum DeepLink: Equatable, Sendable {
    case coffee(id: Coffee.ID)
    case order(coffeeID: Coffee.ID)

    public init?(url: URL) {
        let components = url.pathComponents.filter { $0 != "/" }
        guard url.scheme == "brew", url.host() == "coffee", let id = components.first else { return nil }
        switch components.dropFirst().first {
        case nil: self = .coffee(id: id)
        case "order": self = .order(coffeeID: id)
        default: return nil
        }
    }

    public var coffeeID: Coffee.ID {
        switch self {
        case .coffee(let id), .order(let id): id
        }
    }
}
