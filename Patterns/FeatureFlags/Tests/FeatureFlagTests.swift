import Foundation
import Testing
@testable import FeatureFlags

actor SwitchableFlagSource: RemoteFlagSource {
    private var result: Result<[String: FlagValue], any Error>

    init(_ result: Result<[String: FlagValue], any Error>) {
        self.result = result
    }

    func setResult(_ result: Result<[String: FlagValue], any Error>) {
        self.result = result
    }

    func fetchFlags() async throws -> [String: FlagValue] {
        try result.get()
    }
}

@MainActor
struct FeatureFlagStoreTests {
    let defaults = UserDefaults(suiteName: "FeatureFlagTests-\(UUID().uuidString)")!

    func makeStore(_ remote: [String: FlagValue] = [:], userID: String = "user-1") -> FeatureFlagStore {
        FeatureFlagStore(source: StaticFlagSource(remote), userID: userID, defaults: defaults)
    }

    @Test func usesTheDefaultWhenNothingElseIsSet() async {
        let store = makeStore()
        await store.refresh()

        #expect(store[Flags.newCheckout] == false)
        #expect(store[Flags.freeShippingThreshold] == 50)
        #expect(store[Flags.welcomeMessage] == "Welcome!")
    }

    @Test func remoteValueBeatsTheDefault() async {
        let store = makeStore([
            "new_checkout": .bool(true),
            "free_shipping_threshold": .int(35),
            "welcome_message": .string("Hi!"),
        ])

        await store.refresh()

        #expect(store[Flags.newCheckout] == true)
        #expect(store[Flags.freeShippingThreshold] == 35)
        #expect(store[Flags.welcomeMessage] == "Hi!")
    }

    @Test func localOverrideBeatsRemote() async {
        let store = makeStore(["new_checkout": .bool(true)])
        await store.refresh()

        store.setOverride(false, for: Flags.newCheckout)

        #expect(store[Flags.newCheckout] == false)
        #expect(store.isOverridden(Flags.newCheckout))
    }

    @Test func resettingOverridesFallsBackToRemote() async {
        let store = makeStore(["new_checkout": .bool(true)])
        await store.refresh()
        store.setOverride(false, for: Flags.newCheckout)

        store.resetOverrides()

        #expect(store[Flags.newCheckout] == true)
        #expect(!store.isOverridden(Flags.newCheckout))
    }

    @Test func overridesSurviveARelaunch() {
        makeStore().setOverride(true, for: Flags.applePay)

        let relaunched = makeStore()

        #expect(relaunched[Flags.applePay] == true)
    }

    @Test func wrongTypeFromRemoteFallsBackToTheDefault() async {
        let store = makeStore(["new_checkout": .string("yes")])
        await store.refresh()

        #expect(store[Flags.newCheckout] == false)
    }

    @Test func failedRefreshKeepsLastKnownValues() async {
        let source = SwitchableFlagSource(.success(["new_checkout": .bool(true)]))
        let store = FeatureFlagStore(source: source, userID: "user-1", defaults: defaults)
        await store.refresh()

        await source.setResult(.failure(URLError(.notConnectedToInternet)))
        await store.refresh()

        #expect(store[Flags.newCheckout] == true)
    }
}

@MainActor
struct RolloutTests {
    func enabledCount(percentage: Int, users: Int = 1_000) async -> Int {
        var count = 0
        for index in 0..<users {
            let store = FeatureFlagStore(
                source: StaticFlagSource(["apple_pay": .rollout(percentage: percentage)]),
                userID: "user-\(index)",
                defaults: UserDefaults(suiteName: "RolloutTests-\(percentage)")!
            )
            await store.refresh()
            if store[Flags.applePay] { count += 1 }
        }
        return count
    }

    @Test func zeroPercentEnablesNobody() async {
        #expect(await enabledCount(percentage: 0) == 0)
    }

    @Test func hundredPercentEnablesEveryone() async {
        #expect(await enabledCount(percentage: 100) == 1_000)
    }

    @Test func fiftyPercentEnablesRoughlyHalf() async {
        let count = await enabledCount(percentage: 50)
        #expect((400...600).contains(count))
    }

    @Test func bucketIsStableForTheSameUser() {
        #expect(Rollout.bucket(for: "apple_pay:user-42") == Rollout.bucket(for: "apple_pay:user-42"))
        #expect((0..<100).contains(Rollout.bucket(for: "apple_pay:user-42")))
    }
}

struct FlagValueDecodingTests {
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
