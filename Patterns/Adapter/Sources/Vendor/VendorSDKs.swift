import Foundation

public struct VendorPayload: Sendable, Equatable, CustomStringConvertible {
    public let name: String
    public let properties: [String: String]

    public var description: String {
        let pairs = properties.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)" }
        return ([name] + pairs).joined(separator: " ")
    }
}

/// Simulates a third-party SDK: a non-`Sendable` class with a stringly-typed, callback-based API.
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
