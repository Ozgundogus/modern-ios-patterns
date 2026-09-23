/// Sends every call to several services, so the app can report to more than one vendor.
public struct CompositeAnalytics: AnalyticsService {
    private let services: [any AnalyticsService]

    public init(_ services: [any AnalyticsService]) {
        self.services = services
    }

    public func track(_ event: AnalyticsEvent) async {
        for service in services {
            await service.track(event)
        }
    }

    public func identify(userID: String) async {
        for service in services {
            await service.identify(userID: userID)
        }
    }

    public func flush() async throws {
        for service in services {
            try await service.flush()
        }
    }
}
