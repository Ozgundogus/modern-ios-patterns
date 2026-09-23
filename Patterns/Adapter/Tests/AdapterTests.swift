import Testing
@testable import Adapter

struct LegacyAnalyticsAdapterTests {
    @Test func mapsEventsToTheLegacyFormat() async throws {
        let adapter = LegacyAnalyticsAdapter()

        await adapter.track(.screenViewed(name: "Home"))
        await adapter.track(.productAdded(productID: 42, price: 4.5))
        await adapter.track(.checkoutCompleted(orderID: "A-1", total: 9))
        try await adapter.flush()

        #expect(await adapter.uploaded == [
            VendorPayload(name: "Screen Viewed", properties: ["screen": "Home"]),
            VendorPayload(name: "Product Added", properties: ["product_id": "42", "price": "4.5"]),
            VendorPayload(name: "Order Completed", properties: ["order_id": "A-1", "revenue": "9"]),
        ])
    }

    @Test func nothingIsUploadedBeforeFlush() async {
        let adapter = LegacyAnalyticsAdapter()

        await adapter.track(.screenViewed(name: "Home"))

        #expect(await adapter.uploaded.isEmpty)
    }

    @Test func identifiesTheUser() async {
        let adapter = LegacyAnalyticsAdapter()

        await adapter.identify(userID: "user-1")

        #expect(await adapter.userId == "user-1")
    }
}

struct EventLoggerAdapterTests {
    @Test func mapsEventsToSnakeCaseNamesAndParameters() async {
        let adapter = EventLoggerAdapter()

        await adapter.track(.productAdded(productID: 42, price: 4.5))
        await adapter.track(.checkoutCompleted(orderID: "A-1", total: 9))

        #expect(await adapter.logged == [
            VendorPayload(name: "add_to_cart", properties: ["item_id": "42", "value": "4.5", "currency": "USD"]),
            VendorPayload(name: "purchase", properties: ["transaction_id": "A-1", "value": "9", "currency": "USD"]),
        ])
    }

    @Test func identifiesTheUser() async {
        let adapter = EventLoggerAdapter()

        await adapter.identify(userID: "user-1")

        #expect(await adapter.userID == "user-1")
    }
}

@MainActor
struct CompositeAnalyticsTests {
    @Test func forwardsEveryCallToAllServices() async throws {
        let first = RecordingAnalytics()
        let second = RecordingAnalytics()
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
