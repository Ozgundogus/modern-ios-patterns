import Foundation

public enum CoffeeError: LocalizedError, Equatable {
    case notFound(id: String)
    case unavailable

    public var errorDescription: String? {
        switch self {
        case .notFound: "This coffee is no longer available."
        case .unavailable: "Can't reach the coffee catalog. Check your connection."
        }
    }
}
