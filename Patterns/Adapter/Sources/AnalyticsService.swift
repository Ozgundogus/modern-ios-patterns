/// The interface the app owns. Vendor SDKs are adapted to it, never the other way round.
public protocol AnalyticsService: Sendable {
    func track(_ event: AnalyticsEvent) async
    func identify(userID: String) async
    func flush() async throws
}
