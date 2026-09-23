public struct Banner: Sendable, Equatable, Decodable {
    public enum Style: String, Sendable, Decodable {
        case info
        case promo
    }

    public let title: String
    public let subtitle: String?
    public let style: Style

    public init(title: String, subtitle: String? = nil, style: Style = .info) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case style
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        style = try container.decodeIfPresent(Style.self, forKey: .style) ?? .info
    }
}
