/// One block of a server-driven screen. Unknown types are kept as `.unsupported`,
/// so an old app version can still show the rest of a screen designed for a newer one.
public enum Component: Sendable, Equatable {
    case banner(Banner)
    case product(ProductRow)
    case button(ActionButton)
    case spacer(height: Double)
    case unsupported(type: String)
}

extension Component: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case height
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "banner": self = .banner(try Banner(from: decoder))
        case "product": self = .product(try ProductRow(from: decoder))
        case "button": self = .button(try ActionButton(from: decoder))
        case "spacer": self = .spacer(height: try container.decode(Double.self, forKey: .height))
        default: self = .unsupported(type: type)
        }
    }
}
