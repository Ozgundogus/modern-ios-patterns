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
