#if canImport(SwiftUI)
import SwiftUI

struct AdapterPlayground: View {
    @State private var legacy = LegacyAnalyticsAdapter()
    @State private var eventLogger = EventLoggerAdapter()
    @State private var legacyLog: [VendorPayload] = []
    @State private var eventLoggerLog: [VendorPayload] = []

    var body: some View {
        List {
            Section("App events") {
                Button("Screen viewed") { send(.screenViewed(name: "Product")) }
                Button("Product added") { send(.productAdded(productID: 42, price: 4.5)) }
                Button("Checkout completed") { send(.checkoutCompleted(orderID: "A-1001", total: 9)) }
            }
            Section("LegacyAnalyticsSDK received") {
                log(legacyLog)
            }
            Section("EventLoggerSDK received") {
                log(eventLoggerLog)
            }
        }
    }

    private func log(_ payloads: [VendorPayload]) -> some View {
        ForEach(Array(payloads.enumerated()), id: \.offset) { _, payload in
            Text(payload.description).font(.caption.monospaced())
        }
    }

    private func send(_ event: AnalyticsEvent) {
        Task {
            let analytics = CompositeAnalytics([legacy, eventLogger])
            await analytics.track(event)
            try? await analytics.flush()
            legacyLog = await legacy.uploaded
            eventLoggerLog = await eventLogger.logged
        }
    }
}

#Preview("One event, two SDKs") {
    AdapterPlayground()
}
#endif
