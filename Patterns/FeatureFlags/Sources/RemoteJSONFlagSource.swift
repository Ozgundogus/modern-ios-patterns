import Foundation

/// Fetches JSON like:
/// ```json
/// { "new_checkout": true, "free_shipping_threshold": 35, "apple_pay": { "rollout": 25 } }
/// ```
public struct RemoteJSONFlagSource: RemoteFlagSource {
    private let url: URL
    private let session: URLSession

    public init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    public func fetchFlags() async throws -> [String: FlagValue] {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([String: FlagValue].self, from: data)
    }
}
