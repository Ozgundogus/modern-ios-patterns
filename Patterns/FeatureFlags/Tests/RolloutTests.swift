import Foundation
import Testing
@testable import FeatureFlags

@MainActor
struct RolloutTests {
    func enabledCount(percentage: Int, users: Int = 1_000) async -> Int {
        var count = 0
        for index in 0..<users {
            let store = FeatureFlagStore(
                source: StubFlagSource(["apple_pay": .rollout(percentage: percentage)]),
                userID: "user-\(index)",
                defaults: UserDefaults(suiteName: "RolloutTests-\(percentage)")!
            )
            await store.refresh()
            if store[AppFlags.applePay] { count += 1 }
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
