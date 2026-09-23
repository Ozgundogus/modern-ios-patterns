import Observation

@MainActor
@Observable
public final class SpyAnalyticsService: AnalyticsService {
    public private(set) var events: [AnalyticsEvent] = []
    public private(set) var userID: String?

    public init() {}

    public func track(_ event: AnalyticsEvent) {
        events.append(event)
    }

    public func identify(userID: String) {
        self.userID = userID
    }

    public func flush() {}
}
