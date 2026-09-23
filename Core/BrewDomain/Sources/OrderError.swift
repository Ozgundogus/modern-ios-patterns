import Foundation

public enum OrderError: LocalizedError, Equatable {
    case invalidQuantity
    case unavailable

    public var errorDescription: String? {
        switch self {
        case .invalidQuantity: "Choose between \(Order.quantityRange.lowerBound) and \(Order.quantityRange.upperBound) bags."
        case .unavailable: "Can't place the order right now. Try again in a moment."
        }
    }
}
