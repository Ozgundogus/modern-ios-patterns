/// Simulates a second SDK with a different API and naming rules (snake_case, no batching).
public final class EventLoggerSDK {
    public private(set) var logged: [VendorPayload] = []
    public private(set) var userID: String?

    public init() {}

    public func logEvent(_ name: String, parameters: [String: Any]?) {
        logged.append(VendorPayload(name: name, properties: (parameters ?? [:]).mapValues { "\($0)" }))
    }

    public func setUserID(_ userID: String?) {
        self.userID = userID
    }
}
