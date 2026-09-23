/// Types a flag can hold. `bucket` is the user's stable position (0..<100) for percentage rollouts.
public protocol FlagValueType: Sendable, Equatable {
    static func decode(_ value: FlagValue, bucket: Int) -> Self?
    var flagValue: FlagValue { get }
}

extension Bool: FlagValueType {
    public static func decode(_ value: FlagValue, bucket: Int) -> Bool? {
        switch value {
        case .bool(let enabled): enabled
        case .rollout(let percentage): bucket < percentage
        case .int, .string: nil
        }
    }

    public var flagValue: FlagValue { .bool(self) }
}

extension Int: FlagValueType {
    public static func decode(_ value: FlagValue, bucket: Int) -> Int? {
        if case .int(let number) = value { number } else { nil }
    }

    public var flagValue: FlagValue { .int(self) }
}

extension String: FlagValueType {
    public static func decode(_ value: FlagValue, bucket: Int) -> String? {
        if case .string(let text) = value { text } else { nil }
    }

    public var flagValue: FlagValue { .string(self) }
}
