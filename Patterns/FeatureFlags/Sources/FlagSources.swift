import Foundation

/// Where remote values come from: your own backend, Firebase Remote Config, LaunchDarkly…
/// The rest of the app only sees this protocol.
public protocol RemoteFlagSource: Sendable {
    func fetchFlags() async throws -> [String: FlagValue]
}

/// Fixed values for previews and tests.
public struct StaticFlagSource: RemoteFlagSource {
    public var values: [String: FlagValue]

    public init(_ values: [String: FlagValue] = [:]) {
        self.values = values
    }

    public func fetchFlags() async throws -> [String: FlagValue] {
        values
    }
}

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

extension FlagValue: Codable {
    private enum CodingKeys: String, CodingKey {
        case rollout
    }

    public init(from decoder: any Decoder) throws {
        if let object = try? decoder.container(keyedBy: CodingKeys.self) {
            self = .rollout(percentage: try object.decode(Int.self, forKey: .rollout))
            return
        }
        let container = try decoder.singleValueContainer()
        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else {
            self = .string(try container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if case .rollout(let percentage) = self {
            var object = encoder.container(keyedBy: CodingKeys.self)
            try object.encode(percentage, forKey: .rollout)
            return
        }
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let bool): try container.encode(bool)
        case .int(let int): try container.encode(int)
        case .string(let string): try container.encode(string)
        case .rollout: break
        }
    }
}
