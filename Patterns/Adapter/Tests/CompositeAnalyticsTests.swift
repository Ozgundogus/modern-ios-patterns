import Testing
@testable import Adapter

@MainActor
struct CompositeAnalyticsTests {
    @Test func forwardsEveryCallToAllServices() async throws {
        let first = SpyAnalyticsService()
        let second = SpyAnalyticsService()
        let analytics = CompositeAnalytics([first, second])

        await analytics.identify(userID: "user-1")
        await analytics.track(.screenViewed(name: "Home"))
        try await analytics.flush()

        for service in [first, second] {
            #expect(service.userID == "user-1")
            #expect(service.events == [.screenViewed(name: "Home")])
        }
    }

    @Test func oneEventReachesBothVendorsInTheirOwnFormat() async throws {
        let legacy = LegacyAnalyticsAdapter()
        let eventLogger = EventLoggerAdapter()

        await CompositeAnalytics([legacy, eventLogger]).track(.screenViewed(name: "Home"))
        try await legacy.flush()

        #expect(await legacy.uploaded.map(\.name) == ["Screen Viewed"])
        #expect(await eventLogger.logged.map(\.name) == ["screen_view"])
    }
}
