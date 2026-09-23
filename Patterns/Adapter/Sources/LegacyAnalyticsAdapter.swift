import Foundation

/// Adapts `LegacyAnalyticsSDK` to `AnalyticsService`.
/// The SDK isn't `Sendable`, so the adapter is an actor that owns it and serializes every call.
public actor LegacyAnalyticsAdapter: AnalyticsService {
    private let sdk = LegacyAnalyticsSDK()

    public init() {}

    public func track(_ event: AnalyticsEvent) {
        switch event {
        case .screenViewed(let name):
            sdk.track(eventName: "Screen Viewed", properties: ["screen": name])
        case .productAdded(let productID, let price):
            sdk.track(eventName: "Product Added", properties: ["product_id": productID, "price": price])
        case .checkoutCompleted(let orderID, let total):
            sdk.track(eventName: "Order Completed", properties: ["order_id": orderID, "revenue": total])
        }
    }

    public func identify(userID: String) {
        sdk.identify(userId: userID)
    }

    public func flush() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
            sdk.flush { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    var uploaded: [VendorPayload] { sdk.uploaded }
    var userID: String? { sdk.userId }
}
