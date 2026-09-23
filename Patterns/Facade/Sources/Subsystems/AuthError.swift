import Foundation

public enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case sessionExpired

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials: "Wrong email or password."
        case .sessionExpired: "Your session has expired. Please sign in again."
        }
    }
}
