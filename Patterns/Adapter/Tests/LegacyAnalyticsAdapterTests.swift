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

        #expect(await adapter.userID == "user-1")
    }
}
