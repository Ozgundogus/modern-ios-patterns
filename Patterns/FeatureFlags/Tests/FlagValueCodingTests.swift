import Foundation
import Testing
@testable import FeatureFlags

struct FlagValueCodingTests {
    @Test func decodesRemoteConfigJSON() throws {
        let json = Data("""
        {
            "new_checkout": true,
            "free_shipping_threshold": 35,
            "welcome_message": "Hi!",
            "apple_pay": { "rollout": 25 }
        }
        """.utf8)

        let values = try JSONDecoder().decode([String: FlagValue].self, from: json)

        #expect(values == [
            "new_checkout": .bool(true),
            "free_shipping_threshold": .int(35),
            "welcome_message": .string("Hi!"),
            "apple_pay": .rollout(percentage: 25),
        ])
    }

    @Test func encodingRoundTrips() throws {
        let values: [String: FlagValue] = [
            "a": .bool(false), "b": .int(7), "c": .string("x"), "d": .rollout(percentage: 10),
        ]

        let data = try JSONEncoder().encode(values)

        #expect(try JSONDecoder().decode([String: FlagValue].self, from: data) == values)
    }
}
