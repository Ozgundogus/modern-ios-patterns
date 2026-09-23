import Foundation

/// Adapts `EventLoggerSDK`, which expects snake_case names and its own parameter keys.
public actor EventLoggerAdapter: AnalyticsService {
    private let sdk = EventLoggerSDK()

    public init() {}

    public func track(_ event: AnalyticsEvent) {
        switch event {
        case .screenViewed(let name):
            sdk.logEvent("screen_view", parameters: ["screen_name": name])
        case .productAdded(let productID, let price):
            sdk.logEvent("add_to_cart", parameters: ["item_id": productID, "value": price, "currency": "USD"])
        case .checkoutCompleted(let orderID, let total):
            sdk.logEvent("purchase", parameters: ["transaction_id": orderID, "value": total, "currency": "USD"])
        }
    }

    public func identify(userID: String) {
        sdk.setUserID(userID)
    }

    public func flush() {}

    var logged: [VendorPayload] { sdk.logged }
    var userID: String? { sdk.userID }
}
