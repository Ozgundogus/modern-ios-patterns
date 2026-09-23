import Foundation

public enum AnalyticsEvent: Sendable, Equatable {
    case screenViewed(name: String)
    case productAdded(productID: Int, price: Decimal)
    case checkoutCompleted(orderID: String, total: Decimal)
}
