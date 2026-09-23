import Testing
@testable import Adapter

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
