import Foundation

public enum FlagValue: Sendable, Equatable {
    case bool(Bool)
    case int(Int)
    case string(String)
    /// Enabled for this percentage of users (0...100). Only meaningful for `Bool` flags.
    case rollout(percentage: Int)
}

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

public struct Flag<Value: FlagValueType>: Sendable, Identifiable {
    public let key: String
    public let defaultValue: Value
    public let summary: String

    public var id: String { key }

    public init(_ key: String, default defaultValue: Value, summary: String) {
        self.key = key
        self.defaultValue = defaultValue
        self.summary = summary
    }
}

public enum Flags {
    public static let newCheckout = Flag(
        "new_checkout",
        default: false,
        summary: "One-page checkout instead of the classic three steps"
    )

    public static let applePay = Flag(
        "apple_pay",
        default: false,
        summary: "Show the Apple Pay button"
    )

    public static let freeShippingThreshold = Flag(
        "free_shipping_threshold",
        default: 50,
        summary: "Order total (USD) for free shipping"
    )

    public static let welcomeMessage = Flag(
        "welcome_message",
        default: "Welcome!",
        summary: "Headline on the checkout screen"
    )

    public static let allBool = [newCheckout, applePay]
}

/// Stable bucketing with 64-bit FNV-1a. `hashValue` can't be used because Swift seeds it per process.
public enum Rollout {
    public static func bucket(for identifier: String) -> Int {
        var hash: UInt64 = 0xcbf2_9ce4_8422_2325
        for byte in identifier.utf8 {
            hash ^= UInt64(byte)
            hash &*= 0x0000_0100_0000_01b3
        }
        return Int(hash % 100)
    }
}
