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
