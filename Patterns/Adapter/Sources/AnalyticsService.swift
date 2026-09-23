import Foundation
import Observation

public enum AnalyticsEvent: Sendable, Equatable {
    case screenViewed(name: String)
    case productAdded(productID: Int, price: Decimal)
    case checkoutCompleted(orderID: String, total: Decimal)
}

/// The interface the app owns. Vendor SDKs are adapted to it, never the other way round.
public protocol AnalyticsService: Sendable {
    func track(_ event: AnalyticsEvent) async
    func identify(userID: String) async
    func flush() async throws
}

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

@MainActor
@Observable
public final class RecordingAnalytics: AnalyticsService {
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
