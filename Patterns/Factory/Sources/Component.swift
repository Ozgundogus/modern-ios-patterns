import Foundation

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

public struct ProductRow: Sendable, Equatable, Decodable {
    public let name: String
    public let price: Decimal
    public let badge: String?

    public init(name: String, price: Decimal, badge: String? = nil) {
        self.name = name
        self.price = price
        self.badge = badge
    }
}

public struct ActionButton: Sendable, Equatable, Decodable {
    public let title: String
    public let url: URL

    public init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}

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

public struct ScreenLayout: Sendable, Equatable, Decodable {
    public let title: String
    public let components: [Component]

    public init(title: String, components: [Component]) {
        self.title = title
        self.components = components
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case components
    }

    /// A malformed component is skipped instead of failing the whole screen.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)

        var list = try container.nestedUnkeyedContainer(forKey: .components)
        var components: [Component] = []
        while !list.isAtEnd {
            if let component = try? list.decode(Component.self) {
                components.append(component)
            } else {
                _ = try list.decode(Skipped.self)
            }
        }
        self.components = components
    }

    private struct Skipped: Decodable {}
}
