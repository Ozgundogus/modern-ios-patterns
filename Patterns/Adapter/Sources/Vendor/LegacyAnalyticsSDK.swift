/// Simulates a third-party SDK: a non-`Sendable` class with a stringly-typed, callback-based API.
/// Its naming (`userId`, Title Case events) follows the vendor, not this codebase.
public final class LegacyAnalyticsSDK {
    private var queue: [VendorPayload] = []
    public private(set) var uploaded: [VendorPayload] = []
    public private(set) var userId: String?

    public init() {}

    public func track(eventName: String, properties: [String: Any]?) {
        let serialized = (properties ?? [:]).mapValues { "\($0)" }
        queue.append(VendorPayload(name: eventName, properties: serialized))
    }

    public func identify(userId: String) {
        self.userId = userId
    }

    public func flush(completion: @escaping ((any Error)?) -> Void) {
        uploaded += queue
        queue.removeAll()
        completion(nil)
    }
}
